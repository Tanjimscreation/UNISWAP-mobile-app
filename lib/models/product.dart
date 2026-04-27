import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ItemCondition { likeNew, good, fair }

extension ItemConditionX on ItemCondition {
  String get label {
    switch (this) {
      case ItemCondition.likeNew:
        return 'Like New';
      case ItemCondition.good:
        return 'Good';
      case ItemCondition.fair:
        return 'Fair';
    }
  }

  Color get color {
    switch (this) {
      case ItemCondition.likeNew:
        return AppTheme.success;
      case ItemCondition.good:
        return AppTheme.warning;
      case ItemCondition.fair:
        return AppTheme.textHint;
    }
  }

  Color get bgColor {
    switch (this) {
      case ItemCondition.likeNew:
        return const Color(0xFFECFDF5);
      case ItemCondition.good:
        return const Color(0xFFFEF9C3);
      case ItemCondition.fair:
        return const Color(0xFFF3F4F6);
    }
  }
}

class Product {
  final String id;
  final String title;
  final double priceRm;
  final ItemCondition condition;
  final String imageUrl;
  final bool swapOnly;
  final String category;
  final String sellerName;
  final String? sellerId;
  final DateTime listedAt;

  const Product({
    required this.id,
    required this.title,
    required this.priceRm,
    required this.condition,
    required this.imageUrl,
    this.swapOnly = false,
    this.category = 'General',
    this.sellerName = 'Siti Aisyah',
    this.sellerId,
    required this.listedAt,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'priceRm': priceRm,
        'condition': condition.name,
        'imageUrl': imageUrl,
        'swapOnly': swapOnly,
        'category': category,
        'sellerName': sellerName,
        'sellerId': sellerId,
        'listedAt': listedAt.toIso8601String(),
      };

  factory Product.fromMap(String id, Map<String, dynamic> d) {
    final cond = ItemCondition.values.firstWhere(
      (c) => c.name == (d['condition'] as String?),
      orElse: () => ItemCondition.good,
    );
    final ts = d['listedAt'];
    DateTime listed;
    if (ts is String) {
      listed = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      listed = DateTime.now();
    }
    return Product(
      id: id,
      title: (d['title'] ?? '') as String,
      priceRm: (d['priceRm'] as num?)?.toDouble() ?? 0,
      condition: cond,
      imageUrl: (d['imageUrl'] ?? '') as String,
      swapOnly: (d['swapOnly'] as bool?) ?? false,
      category: (d['category'] ?? 'General') as String,
      sellerName: (d['sellerName'] ?? '') as String,
      sellerId: d['sellerId'] as String?,
      listedAt: listed,
    );
  }
}

final List<Product> mockProducts = [
  Product(
    id: 'p1',
    title: 'Calculus: Early Transcendentals (Stewart 8th Ed)',
    priceRm: 45,
    condition: ItemCondition.good,
    imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop',
    swapOnly: true,
    category: 'Textbooks',
    listedAt: DateTime(2026, 4, 20),
  ),
  Product(
    id: 'p2',
    title: 'White Lab Coat — Size M (Barely Used)',
    priceRm: 25,
    condition: ItemCondition.likeNew,
    imageUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=400&fit=crop',
    category: 'Lab Gear',
    listedAt: DateTime(2026, 4, 18),
  ),
  Product(
    id: 'p3',
    title: 'Casio FX-570EX Scientific Calculator',
    priceRm: 55,
    condition: ItemCondition.likeNew,
    imageUrl: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&h=400&fit=crop',
    category: 'Electronics',
    listedAt: DateTime(2026, 4, 22),
  ),
  Product(
    id: 'p4',
    title: 'Engineering Drawing Kit (Complete Set)',
    priceRm: 18,
    condition: ItemCondition.good,
    imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=400&h=400&fit=crop',
    swapOnly: true,
    category: 'Stationery',
    listedAt: DateTime(2026, 4, 15),
  ),
  Product(
    id: 'p5',
    title: 'LED Desk Lamp with USB Port',
    priceRm: 32,
    condition: ItemCondition.fair,
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057ab6fe?w=400&h=400&fit=crop',
    category: 'Dorm Essentials',
    listedAt: DateTime(2026, 4, 24),
  ),
  Product(
    id: 'p6',
    title: 'Mechanical Keyboard — Blue Switches',
    priceRm: 120,
    condition: ItemCondition.likeNew,
    imageUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=400&h=400&fit=crop',
    category: 'Electronics',
    listedAt: DateTime(2026, 4, 23),
  ),
];
