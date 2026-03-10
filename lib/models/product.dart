import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final String artisanId;
  final DateTime createdAt;
  final int stockQuantity;
  final bool isAvailable;
  final String? aiGeneratedDescription;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.artisanId,
    required this.createdAt,
    this.stockQuantity = 0,
    this.isAvailable = true,
    this.aiGeneratedDescription,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    String? artisanId,
    DateTime? createdAt,
    int? stockQuantity,
    bool? isAvailable,
    String? aiGeneratedDescription,
    List<String>? tags,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      artisanId: artisanId ?? this.artisanId,
      createdAt: createdAt ?? this.createdAt,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      aiGeneratedDescription: aiGeneratedDescription ?? this.aiGeneratedDescription,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'artisanId': artisanId,
      'createdAt': createdAt.toIso8601String(),
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'aiGeneratedDescription': aiGeneratedDescription,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      images: List<String>.from(json['images'] as Iterable),
      artisanId: json['artisanId'] as String,
      createdAt: _parseDateTime(json['createdAt']),
      stockQuantity: (json['stockQuantity'] as int?) ?? 0,
      isAvailable: (json['isAvailable'] as bool?) ?? true,
      aiGeneratedDescription: json['aiGeneratedDescription'] as String?,
      tags: List<String>.from(json['tags'] as Iterable? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as int?) ?? 0,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
