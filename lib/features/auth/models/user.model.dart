// A simple data model for our User
/* class User {
  final String id;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // A factory constructor for creating a new User instance from a map.
  // This is useful when parsing JSON responses from the API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }

  // A method for converting a User instance to a map.
  // This is useful when sending data to the API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
    };
  }
} */ 

/*import 'package:cloud_firestore/cloud_firestore.dart';

// A simple data model for our User
class User {
  final String id;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // A factory constructor for creating a new User instance from a Firestore document.
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return User(
      id: doc.id, // The doc ID is the user's UID
      email: data?['email'] ?? '',
      fullName: data?['fullName'] ?? '',
    );
  }

  // A method for converting a User instance to a map.
  // This is for saving to Firestore.
  Map<String, dynamic> toJson() {
    return {
      // We don't need to save the ID inside the doc,
      // as it's already the document's name.
      'email': email,
      'fullName': fullName,
    };
  }
}*/

/*import 'package:cloud_firestore/cloud_firestore.dart';

// A simple data model for our User
class User {
  final String id;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // --- THIS IS THE NEW METHOD YOU WERE MISSING ---
  // Factory constructor to create a User from a Firestore Document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
    );
  }

  // A method for converting a User instance to a map (for writing to Firestore).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
    };
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';

// A simple data model for our User
class User {
  final String id;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // --- THIS IS THE UPDATED CONSTRUCTOR ---
  // It now correctly expects a strongly-typed DocumentSnapshot
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Get the data from the document
    final data = snapshot.data();

    // Add a null check for safety
    if (data == null) {
      throw Exception('User data not found in Firestore!');
    }

    return User(
      id: snapshot.id, // The doc ID is the user's UID
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
    );
  }

  // --- THIS IS THE UPDATED toJson METHOD ---
  // A method for converting a User instance to a map (for writing to Firestore).
  Map<String, dynamic> toJson() {
    return {
      // We don't need to save the ID inside the doc,
      // as it's already the document's name.
      'email': email,
      'fullName': fullName,
    };
  }
}




