

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/providers/auth_provider.dart'; // 1. We need this to get the user's ID

// Simple provider for the notifier
final feedbackProvider =
    StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  // 2. Give the notifier the ref so it can read other providers
  return FeedbackNotifier(ref);
});

   // StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  // 2. Give the notifier the ref so it can read other providers
  //return FeedbackNotifier(ref);});

// State to track loading status
class FeedbackState {
  final bool isLoading;
  final String? error;

  FeedbackState({this.isLoading = false, this.error});
}

// The Notifier
class FeedbackNotifier extends StateNotifier<FeedbackState> {
  // 3. Store the ref and get a Firestore instance
  final Ref _ref;
  final _firestore = FirebaseFirestore.instance;

  FeedbackNotifier(this._ref) : super(FeedbackState());

  Future<void> submitFeedback({
    required String county,
    required String subCounty,
    required String message,
  }) async {
    // 4. Get the current user
    final user = _ref.read(authProvider);

    // 5. Check if the user is logged in
    if (user == null) {
      throw Exception('You must be logged in to submit feedback.');
    }

    // Set loading state
    state = FeedbackState(isLoading: true);

    try {
      // 6. This is the new Firebase logic
      await _firestore.collection('feedback').add({
        'county': county,
        'subCounty': subCounty,
        'message': message,
        'userId': user.id, // Store who sent it
        'userEmail': user.email, // Store for easy reference
        'userName': user.fullName, // Store for easy reference
        'timestamp': FieldValue.serverTimestamp(), // Store when it was sent
      });

      // Set success state (no loading, no error)
      state = FeedbackState(isLoading: false);
    } catch (e) {
      // Set error state
      state = FeedbackState(isLoading: false, error: e.toString());
      // Re-throw the exception so the UI can catch it
      throw Exception('Failed to submit feedback: $e');
    }
  }
}


