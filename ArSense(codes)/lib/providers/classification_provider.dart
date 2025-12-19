import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../models/classification_history.dart';
import '../database/database_helper.dart';

class ClassificationProvider extends ChangeNotifier {
  // 👇 ADD THIS
  bool showLanding = true;

  void hideLanding() {
    showLanding = false;
    notifyListeners();
  }

  File? _imageFile;
  String? _predictedClass;
  double _confidence = 0.0;
  bool _isLoading = false;
  tfl.Interpreter? _interpreter;
  List<String> _classLabels = [];
  List<ClassificationHistory> _history = [];
  List<Map<String, dynamic>> _classStatistics = [];
  List<Map<String, dynamic>> _dailyStatistics = [];
  List<ClassResult> _allPredictions = []; //
  List<ClassResult> get allPredictions => _allPredictions; //
  String _currentSource = 'camera'; // Default source
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getters
  File? get imageFile => _imageFile;
  String? get predictedClass => _predictedClass;
  double get confidence => _confidence;
  bool get isLoading => _isLoading;
  bool get modelLoaded => _interpreter != null;
  List<String> get classLabels => _classLabels;
  List<ClassificationHistory> get history => _history;
  List<Map<String, dynamic>> get classStatistics => _classStatistics;
  List<Map<String, dynamic>> get dailyStatistics => _dailyStatistics;

  ClassificationProvider() {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await loadModel();
    await loadHistory();
    await loadStatistics();
    await _restoreCurrentImage(); // Restore current image on app start
    return;
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  Future<void> loadModel() async {
    try {
      // Load model
      final modelPath = await _getModelPath('assets/model_unquant.tflite');
      _interpreter = tfl.Interpreter.fromFile(modelPath);

      // Load labels
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _classLabels = labelsData
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading model: $e');
    }
  }

  Future<File> _getModelPath(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File('${(await getTemporaryDirectory()).path}/model.tflite');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512, // Increased from 224 for better quality
      maxHeight: 512, // Increased from 224 for better quality
      imageQuality: 90, // Added image quality setting (90% quality)
    );

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _currentSource = source == ImageSource.camera ? 'camera' : 'gallery';
      await _saveCurrentImage(); // Save current image state
      notifyListeners();
      await classifyImage();
    }
  }

  Future<void> classifyImage() async {
    if (_imageFile == null || _interpreter == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Read and decode image
      final imageBytes = await _imageFile!.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        debugPrint('Failed to decode image');
        return;
      }

      // Resize image to 224x224 (model input size)
      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // Prepare input tensor - reshape to [1, 224, 224, 3]
      final input = _imageToTensor(resizedImage);
      final inputReshaped = input.reshape([1, 224, 224, 3]);

      // Prepare output tensor
      final output = List.generate(
        1 * _classLabels.length,
        (index) => 0.0,
      ).reshape([1, _classLabels.length]);

      // Run inference
      _interpreter!.run(inputReshaped, output);

      // Process results
      final results = _processOutput(List<List<double>>.from(output));

      if (results.isNotEmpty) {
        _predictedClass = results[0]['className'];
        _confidence = results[0]['confidence'] * 100;

        // Create list of all class predictions (ALL 10)
        _allPredictions = results
            .map(
              (result) => ClassResult(
                className: result['className'],
                confidence: result['confidence'] * 100,
              ),
            )
            .toList();

        // Save to history
        await _saveToHistory(_allPredictions);

        // Refresh statistics
        await loadStatistics();
      }
    } catch (e) {
      debugPrint('Error classifying image: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<double> _imageToTensor(img.Image image) {
    // Convert image to normalized tensor values for MobileNet (224x224x3)
    final input = List<double>.filled(224 * 224 * 3, 0.0);
    int index = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        // Convert RGB to normalized values [0,1]
        input[index++] = pixel.r / 255.0;
        input[index++] = pixel.g / 255.0;
        input[index++] = pixel.b / 255.0;
      }
    }

    // Return flat list - TensorFlow Lite will handle reshaping
    return input;
  }

  List<Map<String, dynamic>> _processOutput(List<List<double>> output) {
    final results = <Map<String, dynamic>>[];

    // output is [1, num_classes], so we need output[0] to get the actual probabilities
    if (output.isNotEmpty && output[0].isNotEmpty) {
      final probabilities = output[0];

      for (
        int i = 0;
        i < probabilities.length && i < _classLabels.length;
        i++
      ) {
        results.add({
          'className': _classLabels[i],
          'confidence': probabilities[i],
        });
      }
    }

    // Sort by confidence (highest first)
    results.sort((a, b) => b['confidence'].compareTo(a['confidence']));

    return results;
  }

  Future<void> _saveToHistory(List<ClassResult> allResults) async {
    if (_imageFile == null || _predictedClass == null) return;

    // Save image to app directory
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/classification_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final savedImagePath = '${imagesDir.path}/image_$timestamp.jpg';
    await _imageFile!.copy(savedImagePath);

    // Create history record
    final history = ClassificationHistory(
      className: _predictedClass!,
      confidence: _confidence,
      imagePath: savedImagePath,
      timestamp: DateTime.now(),
      allResults: allResults,
      source: _currentSource,
    );

    await _dbHelper.insertClassification(history);
    await loadHistory();
  }

  Future<void> loadHistory() async {
    _history = await _dbHelper.getClassificationHistory();
    notifyListeners();
  }

  Future<void> loadStatistics() async {
    _classStatistics = await _dbHelper.getClassStatistics();
    _dailyStatistics = await _dbHelper.getDailyStatistics();
    notifyListeners();
  }

  Future<void> clearCurrent() async {
    _imageFile = null;
    _predictedClass = null;
    _confidence = 0.0;
    _allPredictions = []; // ✅ CLEAR ALL PREDICTIONS
    notifyListeners();
  }

  Future<void> deleteHistory(int id) async {
    await _dbHelper.deleteClassification(id);
    await loadHistory();
    await loadStatistics();
  }

  Future<void> clearAllHistory() async {
    await _dbHelper.clearHistory();
    await loadHistory();
    await loadStatistics();
  }

  Future<void> _saveCurrentImage() async {
    // This method can be implemented if needed to persist current image state
    // For now, it's a placeholder to prevent errors
  }

  Future<void> _restoreCurrentImage() async {
    // This method can be implemented if needed to restore image state
    // For now, it's a placeholder to prevent errors
  }

  Map<String, double> getClassAccuracyData() {
    Map<String, double> accuracyData = {};

    for (var stat in _classStatistics) {
      accuracyData[stat['className']] = stat['averageConfidence'].toDouble();
    }

    return accuracyData;
  }

  Map<String, int> getClassFrequencyData() {
    Map<String, int> frequencyData = {};

    for (var stat in _classStatistics) {
      frequencyData[stat['className']] = stat['totalClassifications'];
    }

    return frequencyData;
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}

final Map<String, String> classDescriptions = {
  'fingerprint sensor':
      'Biometric sensor used to identify individuals based on fingerprint patterns.',

  'ultrasonic sensor':
      'Uses ultrasonic waves to measure distance and detect nearby objects.',

  'water level sensor':
      'Detects and monitors the level of water in tanks or containers.',

  'sound sensor':
      'Detects sound intensity and converts audio signals into electrical output.',

  'humidity temperature sensor':
      'Measures both ambient temperature and humidity levels in the environment.',

  'soil moisture sensor':
      'Measures moisture content in soil, commonly used in agriculture systems.',

  'flame sensor':
      'Detects fire or flame presence using infrared light sensitivity.',

  'touch sensor':
      'Detects physical touch or contact through capacitive sensing.',

  'smoke gas sensor':
      'Detects smoke and harmful gases to monitor air quality and safety.',

  'RFID sensor':
      'Uses radio frequency identification to read and identify RFID tags.',
};
