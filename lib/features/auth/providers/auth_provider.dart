
import 'dart:async'; // Import for StreamSubscription
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import '../models/user.model.dart'; // Your User model

// The provider definition remains the same
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

// Using 'profiles' as you confirmed this collection exists
const String _userCollectionName = 'profiles';

class AuthNotifier extends StateNotifier<User?> {
  final _auth = fb_auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // --- THIS IS THE KEY ---
  // We define a reference to our collection that already
  // knows how to convert data to and from our User model.
  late final CollectionReference<User> _userCollection;

  StreamSubscription<User?>? _authStateSubscription;

  AuthNotifier() : super(null) {
    // Initialize our type-safe collection reference
    _userCollection =
        _firestore.collection(_userCollectionName).withConverter<User>(
              // This "fromFirestore" call now EXACTLY matches
              // the signature in your user.model.dart
              fromFirestore: (snapshot, _) => User.fromFirestore(snapshot),
              // This "toFirestore" call also matches
              toFirestore: (user, _) => user.toJson(),
            );

    // This stream now listens for auth changes
    _authStateSubscription = _auth.authStateChanges().asyncMap((firebaseUser) {
      if (firebaseUser == null) {
        return null; // User is logged out
      }
      return _getUserProfile(firebaseUser.uid);
    }).listen((user) {
      state = user; // Update the state
    }, onError: (e) {
      print('Auth Stream Error: $e');
      state = null;
    });
  }

  // --- THIS FUNCTION IS NOW 100% TYPE-SAFE ---
  // It will no longer fail silently.
  Future<User?> _getUserProfile(String uid) async {
    try {
      final doc = await _userCollection.doc(uid).get();
      if (!doc.exists) {
        print('Auth Debug: _getUserProfile call found no document for $uid');
        return null; // No document, so return null
      }
      return doc.data(); // This is now a `User?` object!
    } catch (e) {
      print('Auth Debug: CRITICAL ERROR in _getUserProfile: $e');
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Login just signs in. The stream handles the profile fetch.
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('Invalid credentials.');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    }
  }

  // --- THIS FUNCTION IS NOW 100% TYPE-SAFE ---
  Future<void> register(String fullName, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('Registration failed: no user created.');
      }

      final firebaseUser = userCredential.user!;

      final newUser = User(
        id: firebaseUser.uid,
        email: email,
        fullName: fullName,
      );

      // Save the user's profile using our new type-safe collection
      // We just pass the 'newUser' object directly!
      await _userCollection.doc(firebaseUser.uid).set(newUser);

      // Set state manually
      // This is the "optimistic" update that makes the UI
      // feel fast. The stream will confirm it in the background.
      state = newUser;
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already registered.');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose(); // Call super.dispose()
  }
}












