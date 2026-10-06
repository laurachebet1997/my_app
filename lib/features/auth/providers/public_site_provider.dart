import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/public_sites_model.dart';

// This is the provider that will stream our list of public sites
final publicSiteProvider = StreamProvider<List<PublicSiteModel>>((ref) {
  // 1. Get a reference to the Firestore collection
  final collection = FirebaseFirestore.instance.collection('public_sites');

  // 2. Create a query that orders the sites by the 'name' field, A-Z
  final query = collection.orderBy('name', descending: false);

  // 3. Listen to the stream of snapshots from this query
  final stream = query.snapshots();

  // 4. Map the stream of snapshots into a List of PublicSiteModel objects
  return stream.map((snapshot) {
    return snapshot.docs.map((doc) {
      // For each document, create a PublicSiteModel
      return PublicSiteModel.fromFirestore(doc);
    }).toList(); // Convert the result to a List
  });
});

