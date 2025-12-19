import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/classification_provider.dart';
import '../models/classification_history.dart';
import '../constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedSource = 'All';
  String _selectedClass = 'All Classes';
  final Set<int> _expandedItems = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(child: _buildHistoryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Classification History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBlue,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () => _showMenuOptions(),
              icon: const Icon(Icons.more_vert, color: AppColors.darkBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<ClassificationProvider>(
      builder: (context, provider, child) {
        // Get all available class labels from the model, not just history
        final allClasses = provider.classLabels;

        // Also get classes that have been classified (for display purposes)
        final classifiedClasses =
            provider.history.map((h) => h.className).toSet().toList()..sort();

        // Use all available classes for the filter
        final classes = allClasses.isNotEmpty ? allClasses : classifiedClasses;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Source',
                  ['All', 'Camera', 'Gallery'],
                  _selectedSource,
                  (value) => setState(() => _selectedSource = value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Class',
                  ['All Classes', ...classes],
                  _selectedClass,
                  (value) => setState(() => _selectedClass = value),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) => onChanged(value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Consumer<ClassificationProvider>(
      builder: (context, provider, child) {
        if (provider.history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: AppColors.darkBlueWithOpacity,
                ),
                const SizedBox(height: 16),
                Text(
                  'No classification history yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.darkBlueWithOpacity08,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start classifying images to see history here',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkBlueWithOpacity,
                  ),
                ),
              ],
            ),
          );
        }

        final filteredHistory = _getFilteredHistory(provider.history);

        if (filteredHistory.isEmpty) {
          return Center(
            child: Text(
              'No results match your filters',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkBlueWithOpacity,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredHistory.length,
          itemBuilder: (context, index) {
            final history = filteredHistory[index];
            return _buildHistoryCard(history: history);
          },
        );
      },
    );
  }

  List<ClassificationHistory> _getFilteredHistory(
    List<ClassificationHistory> history,
  ) {
    return history.where((item) {
      bool matchesSource =
          _selectedSource == 'All' ||
          item.source == _selectedSource.toLowerCase();
      bool matchesClass =
          _selectedClass == 'All Classes' || item.className == _selectedClass;

      return matchesSource && matchesClass;
    }).toList();
  }

  Widget _buildHistoryCard({required ClassificationHistory history}) {
    final isExpanded =
        history.id != null && _expandedItems.contains(history.id!);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main card content (always visible)
          InkWell(
            onTap: () {
              if (history.id != null) {
                setState(() {
                  if (isExpanded) {
                    _expandedItems.remove(history.id!);
                  } else {
                    _expandedItems.add(history.id!);
                  }
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image thumbnail
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: history.imagePath.isNotEmpty
                          ? Image.file(
                              File(history.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  color: Colors.grey.shade400,
                                  size: 24,
                                );
                              },
                            )
                          : Icon(
                              Icons.image,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.className,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getConfidenceTextColor(history.confidence),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${history.confidence.toStringAsFixed(1)}% confidence',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getConfidenceTextColor(history.confidence),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getSourceIcon(history.source),
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat(
                                'MMM dd, HH:mm',
                              ).format(history.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  IconButton(
                    onPressed: () => _showDeleteDialog(history),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFF0FB9B1),
                    ), // Dark teal color
                  ),

                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content (only visible when expanded)
          if (isExpanded) _buildExpandedContent(history),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(ClassificationHistory history) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full image preview
          if (history.imagePath.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(history.imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade400,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // All class predictions title
          Text(
            'All Class Predictions:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),

          // List of all predictions
          ...history.allResults.map((result) => _buildPredictionRow(result)),
        ],
      ),
    );
  }

  Widget _buildPredictionRow(ClassResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Class name
          Expanded(
            flex: 3,
            child: Text(
              result.className,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          // Confidence percentage
          SizedBox(
            width: 60,
            child: Text(
              '${result.confidence.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getConfidenceTextColor(result.confidence),
              ),
            ),
          ),

          // Progress bar
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: result.confidence / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF4DD0E1), // Teal-blue color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceTextColor(double confidence) {
    if (confidence >= 80) return Color(0xFF0A2540); // Dark blue color
    if (confidence >= 60) return Color(0xFF0A2540); // Dark blue color
    return Color(0xFF0A2540); // Dark blue color
  }

  IconData _getSourceIcon(String source) {
    switch (source.toLowerCase()) {
      case 'camera':
        return Icons.camera_alt;
      case 'gallery':
        return Icons.photo_library;
      default:
        return Icons.image;
    }
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Clear All History'),
              onTap: () {
                Navigator.pop(context);
                _showClearHistoryDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(ClassificationHistory history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this classification history entry?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ClassificationProvider>(
                context,
                listen: false,
              ).deleteHistory(history.id!);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all classification history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ClassificationProvider>(
                context,
                listen: false,
              ).clearAllHistory();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
