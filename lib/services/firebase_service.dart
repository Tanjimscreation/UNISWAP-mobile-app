import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Centralized Firebase singletons used across the app.
class FirebaseService {
  FirebaseService._();

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get db => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Collections
  static CollectionReference<Map<String, dynamic>> get users =>
      db.collection('users');

  static CollectionReference<Map<String, dynamic>> get listings =>
      db.collection('listings');

  /// Uploads [file] to `avatars/{uid}.jpg` and returns the download URL.
  static Future<String> uploadAvatar(String uid, File file) async {
    final ref = storage.ref('avatars/$uid.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  /// Uploads a listing image to `listings/{listingId}/{fileName}` and
  /// returns the download URL.
  static Future<String> uploadListingImage(
    String listingId,
    File file, {
    String fileName = 'cover.jpg',
  }) async {
    final ref = storage.ref('listings/$listingId/$fileName');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
