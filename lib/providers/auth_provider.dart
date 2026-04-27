import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';

/// Auth + profile + listings provider, backed by Firebase Auth, Firestore
/// (`users/{uid}`, `listings`) and Firebase Storage.
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _authSub = FirebaseService.auth.authStateChanges().listen(_onAuthChanged);
  }

  // ── State ──
  AppUser? _user;
  bool _isLoggedIn = false;
  List<Product> _listings = List<Product>.from(mockProducts);

  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listingsSub;

  // ── Getters ──
  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  List<Product> get listings => List.unmodifiable(_listings);

  String? get email => _user?.email;
  String? get fullName => _user?.fullName;
  String? get faculty => _user?.faculty;
  String? get campus => _user?.campus;
  String get location => _user?.campusLabel ?? 'UTM Skudai';
  String get trustScore => (_user?.trustScore ?? 5.0).toStringAsFixed(1);
  int get successfulSwaps => _user?.successfulSwaps ?? 0;

  // ── Validation ──
  static final RegExp _utmEmail =
      RegExp(r'^[a-zA-Z0-9._%+-]+@(graduate\.utm\.my|utm\.my)$');

  /// Static so it can be unit-tested without needing Firebase initialized.
  static bool isUTMEmail(String email) =>
      _utmEmail.hasMatch(email.trim().toLowerCase());

  bool isValidUTMEmail(String email) => isUTMEmail(email);

  // ── Auth state plumbing ──
  Future<void> _onAuthChanged(User? fbUser) async {
    await _profileSub?.cancel();
    _profileSub = null;

    if (fbUser == null) {
      _user = null;
      _isLoggedIn = false;
      _listings = List<Product>.from(mockProducts);
      await _listingsSub?.cancel();
      _listingsSub = null;
      notifyListeners();
      return;
    }

    _isLoggedIn = true;
    // Live profile subscription.
    _profileSub = FirebaseService.users.doc(fbUser.uid).snapshots().listen(
      (snap) {
        if (snap.exists) {
          _user = AppUser.fromDoc(snap);
        } else {
          // Profile not yet created (e.g. mid-registration); fallback shell.
          _user = AppUser(
            id: fbUser.uid,
            fullName: fbUser.displayName ?? '',
            email: fbUser.email ?? '',
            faculty: '',
            campus: 'Skudai',
            avatarUrl: fbUser.photoURL,
            memberSince: fbUser.metadata.creationTime ?? DateTime.now(),
          );
        }
        notifyListeners();
      },
    );

    _attachListingsStream();
  }

  void _attachListingsStream() {
    _listingsSub?.cancel();
    _listingsSub = FirebaseService.listings
        .orderBy('listedAt', descending: true)
        .snapshots()
        .listen((qs) {
      if (qs.docs.isEmpty) {
        // Keep mock catalog visible until the seller-economy boots.
        _listings = List<Product>.from(mockProducts);
      } else {
        _listings =
            qs.docs.map((d) => Product.fromMap(d.id, d.data())).toList();
      }
      notifyListeners();
    });
  }

  // ── Auth actions ──
  Future<String?> register({
    required String email,
    required String fullName,
    required String password,
    required String faculty,
    required String campus,
    String? phoneNumber,
    required bool acceptedTerms,
  }) async {
    if (!isValidUTMEmail(email)) {
      return 'UniSwap is exclusive to UTM students.\nUse your @utm.my or @graduate.utm.my email.';
    }
    if (fullName.trim().isEmpty) return 'Please enter your full name.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    if (faculty.isEmpty) return 'Please select your faculty.';
    if (campus.isEmpty) return 'Please select your campus.';
    if (!acceptedTerms) {
      return 'Please accept the Campus Safety & Fair Trade terms.';
    }

    try {
      final cred = await FirebaseService.auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final uid = cred.user!.uid;
      await cred.user!.updateDisplayName(fullName.trim());

      final profile = AppUser(
        id: uid,
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        faculty: faculty,
        campus: campus,
        phoneNumber: phoneNumber,
        trustScore: 5.0,
        successfulSwaps: 0,
        totalListings: 0,
        memberSince: DateTime.now(),
      );
      await FirebaseService.users.doc(uid).set(profile.toMap());
      return null;
    } on FirebaseAuthException catch (e) {
      return _humanizeAuthError(e);
    } catch (_) {
      return 'Could not create your account. Please try again.';
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (!isValidUTMEmail(email)) return 'Please use a valid UTM email.';
    if (password.isEmpty) return 'Password is required.';

    try {
      await FirebaseService.auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _humanizeAuthError(e);
    } catch (_) {
      return 'Could not sign in. Please try again.';
    }
  }

  Future<void> logout() async {
    await FirebaseService.auth.signOut();
  }

  // ── Listings ──
  Future<void> addListing(Product p) async {
    final fbUser = FirebaseService.auth.currentUser;
    final enriched = Product(
      id: p.id,
      title: p.title,
      priceRm: p.priceRm,
      condition: p.condition,
      imageUrl: p.imageUrl,
      swapOnly: p.swapOnly,
      category: p.category,
      sellerName: _user?.fullName ?? p.sellerName,
      sellerId: fbUser?.uid,
      listedAt: p.listedAt,
    );
    if (fbUser == null) {
      // Offline / unauthenticated fallback — keep local-only listing.
      _listings = [enriched, ..._listings];
      notifyListeners();
      return;
    }
    await FirebaseService.listings.add(enriched.toMap());
  }

  // ── Helpers ──
  String _humanizeAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'That UTM email is already registered.';
      case 'invalid-email':
        return 'Email address looks invalid.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and retry.';
      default:
        return e.message ?? 'Authentication error (${e.code}).';
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    _listingsSub?.cancel();
    super.dispose();
  }
}
