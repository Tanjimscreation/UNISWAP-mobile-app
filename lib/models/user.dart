import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String faculty;
  final String campus;
  final String? phoneNumber;
  final String? avatarUrl;
  final double trustScore;
  final int successfulSwaps;
  final int totalListings;
  final bool verified;
  final DateTime memberSince;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.faculty,
    required this.campus,
    this.phoneNumber,
    this.avatarUrl,
    this.trustScore = 5.0,
    this.successfulSwaps = 0,
    this.totalListings = 0,
    this.verified = true,
    required this.memberSince,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return fullName.isNotEmpty ? fullName[0] : '?';
  }

  String get campusLabel =>
      campus == 'KL' ? 'UTM Kuala Lumpur' : 'UTM Skudai';

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'faculty': faculty,
        'campus': campus,
        'phoneNumber': phoneNumber,
        'avatarUrl': avatarUrl,
        'trustScore': trustScore,
        'successfulSwaps': successfulSwaps,
        'totalListings': totalListings,
        'verified': verified,
        'memberSince': Timestamp.fromDate(memberSince),
      };

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const <String, dynamic>{};
    final ts = d['memberSince'];
    return AppUser(
      id: doc.id,
      fullName: (d['fullName'] ?? '') as String,
      email: (d['email'] ?? '') as String,
      faculty: (d['faculty'] ?? '') as String,
      campus: (d['campus'] ?? '') as String,
      phoneNumber: d['phoneNumber'] as String?,
      avatarUrl: d['avatarUrl'] as String?,
      trustScore: (d['trustScore'] as num?)?.toDouble() ?? 5.0,
      successfulSwaps: (d['successfulSwaps'] as num?)?.toInt() ?? 0,
      totalListings: (d['totalListings'] as num?)?.toInt() ?? 0,
      verified: (d['verified'] as bool?) ?? true,
      memberSince: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
    String? faculty,
    String? campus,
    String? phoneNumber,
    String? avatarUrl,
    double? trustScore,
    int? successfulSwaps,
    int? totalListings,
    bool? verified,
    DateTime? memberSince,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      faculty: faculty ?? this.faculty,
      campus: campus ?? this.campus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      trustScore: trustScore ?? this.trustScore,
      successfulSwaps: successfulSwaps ?? this.successfulSwaps,
      totalListings: totalListings ?? this.totalListings,
      verified: verified ?? this.verified,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}
