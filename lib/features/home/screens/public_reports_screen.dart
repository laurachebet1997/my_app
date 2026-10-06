
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/models/feedback.model.dart';
import '../../auth/providers/feedback_stream_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// 1. Define the class with the CORRECT name: PublicReportsScreen
class PublicReportsScreen extends ConsumerWidget {
  const PublicReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Watch the feedback stream provider (this is the dynamic data)
    final feedbackStream = ref.watch(feedbackStreamProvider);
    final theme = Theme.of(context);

    // 3. Use the .when() to handle loading, data, and error states
    return feedbackStream.when(
      // --- LOADING STATE ---
      loading: () => const Center(child: CircularProgressIndicator()),

      // --- ERROR STATE ---
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error loading reports: ${err.toString()}',
            textAlign: TextAlign.center,
          ),
        ),
      ),

      // --- DATA STATE ---
      data: (List<FeedbackModel> feedbackList) {
        // 4. Handle the case where there is no feedback yet
        if (feedbackList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No public reports found',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Be the first to submit feedback!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // 5. If we have data, show it in a list
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: feedbackList.length,
          itemBuilder: (context, index) {
            final feedback = feedbackList[index];

            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  child: Icon(
                    Icons.comment_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                title: Text(
                  feedback.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${feedback.county} • ${timeago.format(feedback.timestamp)}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  // Later, we can open a detail page for this report
                },
              ),
            );
          },
        );
      },
    );
  }
}

