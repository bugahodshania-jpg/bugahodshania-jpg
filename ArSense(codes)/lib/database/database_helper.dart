import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/classification_history.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'teachable_machine.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE classification_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        className TEXT NOT NULL,
        confidence REAL NOT NULL,
        imagePath TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        allResults TEXT NOT NULL,
        source TEXT NOT NULL DEFAULT 'unknown'
      )
    ''');

    await db.execute('''
      CREATE TABLE class_statistics (
        className TEXT PRIMARY KEY,
        totalClassifications INTEGER NOT NULL DEFAULT 0,
        averageConfidence REAL NOT NULL DEFAULT 0.0,
        highestConfidence REAL NOT NULL DEFAULT 0.0,
        lowestConfidence REAL NOT NULL DEFAULT 0.0,
        lastUpdated INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Clear corrupted data from version 1
      await db.delete('classification_history');
      await db.delete('class_statistics');
    }
    if (oldVersion < 3) {
      // Add source column for version 3
      await db.execute(
        'ALTER TABLE classification_history ADD COLUMN source TEXT NOT NULL DEFAULT "unknown"',
      );
    }
  }

  Future<int> insertClassification(ClassificationHistory classification) async {
    final db = await database;

    // Insert classification history
    final id = await db.insert('classification_history', {
      'className': classification.className,
      'confidence': classification.confidence,
      'imagePath': classification.imagePath,
      'timestamp': classification.timestamp.millisecondsSinceEpoch,
      'allResults': jsonEncode(
        classification.allResults.map((r) => r.toMap()).toList(),
      ),
      'source': classification.source,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Update class statistics
    await _updateClassStatistics(classification);

    return id;
  }

  Future<void> _updateClassStatistics(
    ClassificationHistory classification,
  ) async {
    final db = await database;

    // Get current statistics
    final List<Map<String, dynamic>> stats = await db.query(
      'class_statistics',
      where: 'className = ?',
      whereArgs: [classification.className],
    );

    if (stats.isEmpty) {
      // Insert new statistics
      await db.insert('class_statistics', {
        'className': classification.className,
        'totalClassifications': 1,
        'averageConfidence': classification.confidence,
        'highestConfidence': classification.confidence,
        'lowestConfidence': classification.confidence,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      // Update existing statistics
      final currentStats = stats.first;
      final totalClassifications = currentStats['totalClassifications'] + 1;
      final currentAverage = currentStats['averageConfidence'];
      final newAverage =
          (currentAverage * (totalClassifications - 1) +
              classification.confidence) /
          totalClassifications;

      await db.update(
        'class_statistics',
        {
          'totalClassifications': totalClassifications,
          'averageConfidence': newAverage,
          'highestConfidence':
              classification.confidence > currentStats['highestConfidence']
              ? classification.confidence
              : currentStats['highestConfidence'],
          'lowestConfidence':
              classification.confidence < currentStats['lowestConfidence']
              ? classification.confidence
              : currentStats['lowestConfidence'],
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'className = ?',
        whereArgs: [classification.className],
      );
    }
  }

  Future<List<ClassificationHistory>> getClassificationHistory({
    int limit = 100,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'classification_history',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    debugPrint('Found ${maps.length} history records in database');

    final List<ClassificationHistory> history = [];
    for (int i = 0; i < maps.length; i++) {
      try {
        final historyItem = ClassificationHistory.fromMap(maps[i]);
        history.add(historyItem);
        debugPrint(
          'Successfully parsed history record ${i + 1}: ${historyItem.className}',
        );
      } catch (e) {
        debugPrint('Error parsing history record ${i + 1}: $e');
        debugPrint('Record data: ${maps[i]}');
      }
    }

    debugPrint('Returning ${history.length} valid history records');
    return history;
  }

  Future<List<Map<String, dynamic>>> getClassStatistics() async {
    final db = await database;
    return await db.query(
      'class_statistics',
      orderBy: 'totalClassifications DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getDailyStatistics() async {
    final db = await database;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return await db.rawQuery(
      '''
      SELECT 
        DATE(datetime(timestamp/1000, 'unixepoch')) as date,
        COUNT(*) as totalClassifications,
        AVG(confidence) as averageConfidence
      FROM classification_history 
      WHERE timestamp >= ?
      GROUP BY DATE(datetime(timestamp/1000, 'unixepoch'))
      ORDER BY date DESC
    ''',
      [weekAgo.millisecondsSinceEpoch],
    );
  }

  Future<void> deleteClassification(int id) async {
    final db = await database;

    // Get the classification record before deleting to update statistics
    final List<Map<String, dynamic>> records = await db.query(
      'classification_history',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (records.isNotEmpty) {
      final record = records.first;
      await db.delete(
        'classification_history',
        where: 'id = ?',
        whereArgs: [id],
      );

      // Update class statistics after deletion
      await _updateStatisticsAfterDeletion(
        record['className'],
        record['confidence'],
      );
    }
  }

  Future<void> _updateStatisticsAfterDeletion(
    String className,
    double deletedConfidence,
  ) async {
    final db = await database;

    // Get current statistics
    final List<Map<String, dynamic>> stats = await db.query(
      'class_statistics',
      where: 'className = ?',
      whereArgs: [className],
    );

    if (stats.isNotEmpty) {
      final currentStats = stats.first;
      final totalClassifications = currentStats['totalClassifications'] - 1;

      if (totalClassifications <= 0) {
        // Remove the class statistics if no more classifications exist
        await db.delete(
          'class_statistics',
          where: 'className = ?',
          whereArgs: [className],
        );
      } else {
        // Recalculate average confidence (this is simplified - ideally you'd store all values)
        // For now, we'll keep the existing average and just update the count
        await db.update(
          'class_statistics',
          {
            'totalClassifications': totalClassifications,
            'lastUpdated': DateTime.now().millisecondsSinceEpoch,
          },
          where: 'className = ?',
          whereArgs: [className],
        );
      }
    }
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('classification_history');
    await db.delete('class_statistics');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
