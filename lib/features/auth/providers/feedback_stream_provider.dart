import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback.model.dart'; // Import our new model

// 1. Create a simple provider for the Firestore instance
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// 2. Create the StreamProvider
final feedbackStreamProvider = StreamProvider<List<FeedbackModel>>((ref) {
  // Get the Firestore instance
  final firestore = ref.watch(firestoreProvider);

  // 3. Get the collection
  final collection = firestore.collection('feedback').orderBy(
        'timestamp',
        descending: true,
      );

  // 4. Listen to the stream (snapshots)
  final stream = collection.snapshots();

  // 5. Map the stream of QuerySnapshots to a List<FeedbackModel>
  return stream.map((snapshot) {
    // For each document in the snapshot, create a FeedbackModel
    return snapshot.docs.map((doc) {
      return FeedbackModel.fromFirestore(doc);
    }).toList(); // Convert the iterable to a list
  });
});

