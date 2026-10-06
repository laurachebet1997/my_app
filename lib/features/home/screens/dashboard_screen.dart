

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
// Import our new model (we'll need to create this file)
// ignore: unused_import
import '../../auth/models/feedback.model.dart'; 
// Import your new stream provider
import '../../auth/providers/feedback_stream_provider.dart'; 

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the new feedback stream provider
    final feedbackAsync = ref.watch(feedbackStreamProvider);

    // 2. Handle the different states: loading, error, data
    return feedbackAsync.when(
      // --- LOADING STATE ---
      loading: () => const Center(child: CircularProgressIndicator()),
      
      // --- ERROR STATE ---
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading feedback: $err'),
        ),
      ),
      
      // --- DATA STATE ---
      data: (feedbackList) {
        // If there's no data, show a message
        if (feedbackList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No feedback submitted yet.'),
              ],
            ),
          );
        }

        // --- Process data for charts ---
        final totalReports = feedbackList.length;
        
        // Calculate feedback by county
        final countyCounts = <String, int>{};
        for (var feedback in feedbackList) {
          // Ensure county names are consistently cased for grouping
          final county = feedback.county.trim().capitalize();
          if (county.isEmpty) continue; // Skip empty county names
          countyCounts[county] = (countyCounts[county] ?? 0) + 1;
        }

        // Create pie chart sections from county data
        final pieSections = countyCounts.entries.map((entry) {
          // Make sure value is not zero
          if (entry.value == 0) return null; 
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}\n(${entry.value})',
            // Simple color logic
            color: Colors.primaries[countyCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }).whereType<PieChartSectionData>().toList(); // Filter out nulls


        // --- Build the UI ---
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total Reports Card
              _buildStatCard(
                context,
                'Total Reports',
                totalReports.toString(),
                Icons.bar_chart,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              
              // Unique Counties Card
              _buildStatCard(
                context,
                'Counties Reported',
                countyCounts.keys.length.toString(),
                Icons.map,
                Colors.green,
              ),
              const SizedBox(height: 24),

              // Pie Chart Card
              Text(
                'Feedback by County',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 250,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: pieSections.isEmpty
                        ? const Center(child: Text('No data for chart.'))
                        : PieChart(
                            PieChartData(
                              sections: pieSections,
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget for stat cards
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper extension to capitalize strings for consistent grouping
extension StringExtension on String {
    String capitalize() {
      if (isEmpty) return "";
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}



