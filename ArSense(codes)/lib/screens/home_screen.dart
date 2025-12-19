import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/classification_provider.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLanding = true;
  bool _showPredictionPopup = false; // Control prediction popup visibility

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen to provider changes to show/hide prediction popup
    final provider = Provider.of<ClassificationProvider>(context, listen: true);
    if (provider.allPredictions.isNotEmpty &&
        !provider.isLoading &&
        !_showPredictionPopup) {
      setState(() {
        _showPredictionPopup = true;
      });
    } else if ((provider.allPredictions.isEmpty || provider.isLoading) &&
        _showPredictionPopup) {
      setState(() {
        _showPredictionPopup = false;
      });
    }
  }

  void _hidePredictionPopup() {
    setState(() {
      _showPredictionPopup = false;
    });
  }

  Widget _buildLandingPage(BuildContext context) {
    const Color darkBlue = Color(0xFF0A2540);
    const Color tealBlue = Color(0xFF0FB9B1);

    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBlue, tealBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // =========================
              // ✅ SKIP BUTTON (TOP RIGHT)
              // =========================
              Positioned(
                top: 8,
                right: 16,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(initialIndex: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // =========================
              // MAIN CONTENT
              // =========================
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // --- Logo / Icon ---
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_2.png',
                        width: 175,
                        height: 175,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'ArSense',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Scan or upload a photo to\nlearn which Arduino sensor you’re using',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // --- Buttons ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Scan Sensor
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showLanding = false;
                              });
                              Provider.of<ClassificationProvider>(
                                context,
                                listen: false,
                              ).pickImage(ImageSource.camera);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Scan Sensor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Upload Photo
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showLanding = false;
                              });
                              Provider.of<ClassificationProvider>(
                                context,
                                listen: false,
                              ).pickImage(ImageSource.gallery);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Upload Photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF0A2540);
    const Color tealBlue = Color(0xFF0FB9B1);
    const Color lightWhite = Color(0xFFF5F8FA);
    const Color greyText = Color(0xFF6B7280);

    final LinearGradient buttonGradient = const LinearGradient(
      colors: [darkBlue, tealBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // Hide AppBar on landing page
      appBar: _showLanding
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: const IconThemeData(color: Color(0xFF0A2540)),
              centerTitle: true,
            ),
      body: _showLanding
          ? _buildLandingPage(context)
          : Consumer<ClassificationProvider>(
              builder: (context, provider, child) {
                return SafeArea(
                  bottom: !_showLanding,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // --- Logo Section ---
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 175,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/logo_3.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),

                            // --- Image Container ---
                            Container(
                              height: 375,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: darkBlue.withValues(alpha: 0.2),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                color: darkBlue.withValues(alpha: 0.05),
                              ),
                              child: provider.imageFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        provider.imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 64,
                                            color: greyText,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Select an image to classify',
                                            style: TextStyle(
                                              color: darkBlue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // --- Camera & Gallery Buttons ---
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: buttonGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () => provider.pickImage(
                                        ImageSource.camera,
                                      ),
                                      icon: const Icon(Icons.camera_alt),
                                      label: const Text('Camera'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: buttonGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () => provider.pickImage(
                                        ImageSource.gallery,
                                      ),
                                      icon: const Icon(Icons.photo_library),
                                      label: const Text('Gallery'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // --- Clear button ---
                            if (provider.imageFile != null)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: provider.clearCurrent,
                                  icon: const Icon(Icons.clear),
                                  label: const Text('Clear Image'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: greyText,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // --- Floating prediction box ---
                      if (_showPredictionPopup &&
                          provider.allPredictions.isNotEmpty &&
                          !provider.isLoading)
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              color: darkBlue.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      if (_showPredictionPopup &&
                          provider.allPredictions.isNotEmpty &&
                          !provider.isLoading)
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: lightWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: darkBlue.withAlpha(51)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(26),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Prediction Results',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Most detected class display
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: darkBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: darkBlue.withAlpha(51),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: darkBlue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${provider.allPredictions.first.className}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkBlue,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${provider.allPredictions.first.confidence.toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: tealBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: provider.allPredictions.map((
                                        item,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  item.className,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: darkBlue,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: darkBlue
                                                            .withValues(
                                                              alpha: 0.1,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    FractionallySizedBox(
                                                      widthFactor:
                                                          item.confidence / 100,
                                                      child: Container(
                                                        height: 8,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  darkBlue
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  tealBlue,
                                                                ],
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              SizedBox(
                                                width: 30,
                                                child: Text(
                                                  '${item.confidence.toStringAsFixed(0)}%',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkBlue,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: buttonGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _hidePredictionPopup();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Close'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
