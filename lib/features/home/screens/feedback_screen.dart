import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:google_fonts/google_fonts.dart';

//import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/feedback_provider.dart';



//import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  // 1. We no longer need name and email controllers
  final _countyController = TextEditingController();
  final _subCountyController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    // 2. Remove them from dispose() as well
    _countyController.dispose();
    _subCountyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get the values
    final county = _countyController.text;
    final subCounty = _subCountyController.text;
    final message = _messageController.text;

    try {
      // 3. Call the provider without name and email
      await ref.read(feedbackProvider.notifier).submitFeedback(
            county: county,
            subCounty: subCounty,
            message: message,
          );

      // Show success message and clear form
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState?.reset();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the loading state from the provider
    final feedbackState = ref.watch(feedbackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Submit your feedback, complaint, or report an incident. Your report is anonymous, but your user ID will be attached.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // 4. Name and Email TextFormFields are now removed.

              // County Field
              TextFormField(
                controller: _countyController,
                decoration: const InputDecoration(
                  labelText: 'County',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a county';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sub-County Field
              TextFormField(
                controller: _subCountyController,
                decoration: const InputDecoration(
                  labelText: 'Sub-County',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sub-county';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message / Report',
                  hintText: 'Describe the incident or feedback...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: feedbackState.isLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: feedbackState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('SUBMIT FEEDBACK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


