import 'package:cloud_firestore/cloud_firestore.dart';

// This class defines the data structure for a "Public Site"
class PublicSiteModel {
  final String id;
  final String name;
  final String county;
  final String subCounty;
  final String description;
  final String imageUrl;
  final String hours;
  final GeoPoint coordinates; // For the map

  PublicSiteModel({
    required this.id,
    required this.name,
    required this.county,
    required this.subCounty,
    required this.description,
    required this.imageUrl,
    required this.hours,
    required this.coordinates,
  });

  // Factory constructor to create a PublicSiteModel from a Firestore document
  factory PublicSiteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PublicSiteModel(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      county: data['county'] ?? 'Unknown County',
      subCounty: data['subCounty'] ?? 'Unknown Sub-County',
      description: data['description'] ?? 'No description available.',
      imageUrl: data['imageUrl'] ?? 'https://placehold.co/600x400/005A34/white?text=Site+Image',
      hours: data['hours'] ?? 'Hours not specified',
      coordinates: data['coordinates'] ?? const GeoPoint(0, 0), // Default to 0,0
    );
  }
}

