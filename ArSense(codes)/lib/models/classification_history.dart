import 'dart:convert';

class ClassificationHistory {
  final int? id;
  final String className;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;
  final List<ClassResult> allResults;
  final String source; // 'camera' or 'gallery'

  ClassificationHistory({
    this.id,
    required this.className,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
    required this.allResults,
    required this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'confidence': confidence,
      'imagePath': imagePath,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'allResults': allResults.map((r) => r.toMap()).toList(),
      'source': source,
    };
  }

  factory ClassificationHistory.fromMap(Map<String, dynamic> map) {
    return ClassificationHistory(
      id: map['id'],
      className: map['className'],
      confidence: map['confidence'],
      imagePath: map['imagePath'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      allResults: List<ClassResult>.from(
        jsonDecode(map['allResults']).map((r) => ClassResult.fromMap(r)),
      ),
      source: map['source'] ?? 'unknown', // Default for existing records
    );
  }
}

class ClassResult {
  final String className;
  final double confidence;

  ClassResult({required this.className, required this.confidence});

  Map<String, dynamic> toMap() {
    return {'className': className, 'confidence': confidence};
  }

  factory ClassResult.fromMap(Map<String, dynamic> map) {
    return ClassResult(
      className: map['className'],
      confidence: map['confidence'],
    );
  }
}
