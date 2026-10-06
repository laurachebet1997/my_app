/*import 'package:cloud_firestore/cloud_firestore.dart';



class FeedbackModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String county;
  final String subCounty;
  final String subject; // <-- The missing field
  final String message;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.county,
    required this.subCounty,
    required this.subject, // <-- The missing field
    required this.message,
    required this.timestamp,
  });

  // Factory constructor to create a FeedbackModel from a Firestore document
  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeedbackModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      county: data['county'] ?? '',
      subCounty: data['subCounty'] ?? '',
      subject: data['subject'] ?? '', // <-- The missing field
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String subject;
  final String category;
  final String message;
  final String county;
  final String subCounty;
  final String submittedBy;
  final String email;
  final DateTime timestamp;
  // --- THIS IS THE NEW FIELD THAT WAS MISSING ---
  final GeoPoint location;

  FeedbackModel({
    required this.id,
    required this.subject,
    required this.category,
    required this.message,
    required this.county,
    required this.subCounty,
    required this.submittedBy,
    required this.email,
    required this.timestamp,
    required this.location, // --- ADD IT TO THE CONSTRUCTOR ---
  });

  // Factory constructor to create a User from a Firestore Document
  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle missing or invalid location data
    GeoPoint locationData;
    if (data['location'] is GeoPoint) {
      locationData = data['location'] as GeoPoint;
    } else {
      // Provide a default location (e.s., Nairobi) if data is bad
      locationData = const GeoPoint(-1.286389, 36.817223);
    }

    return FeedbackModel(
      id: doc.id,
      subject: data['subject'] ?? 'No Subject',
      category: data['category'] ?? 'Uncategorized',
      message: data['message'] ?? '',
      county: data['county'] ?? '',
      subCounty: data['subCounty'] ?? '',
      submittedBy: data['submittedBy'] ?? 'Anonymous',
      email: data['email'] ?? '',
      timestamp: (data['timestamp'] as Timestamp? ?? Timestamp.now()).toDate(),
      // --- ASSIGN THE LOCATION DATA ---
      location: locationData,
    );
  }

  // No changes needed for toJson, it's set by the provider.
}

