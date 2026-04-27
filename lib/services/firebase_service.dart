import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Centralized Firebase singletons used across the app.
class FirebaseService {
  FirebaseService._();

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  // Collections
  static CollectionReference<Map<String, dynamic>> get users =>
      db.collection('users');

  static CollectionReference<Map<String, dynamic>> get listings =>
      db.collection('listings');
}
