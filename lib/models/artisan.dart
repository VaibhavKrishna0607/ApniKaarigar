import 'package:cloud_firestore/cloud_firestore.dart';

class Artisan {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String shopName;
  final String shopDescription;
  final String address;
  final String city;
  final String state;
  final List<String> specialties;
  final DateTime joinedAt;
  final double rating;
  final int totalOrders;
  final int totalProducts;
  final bool isVerified;
  final String? upiId;
  final String? bankDetails;

  Artisan({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.shopName,
    required this.shopDescription,
    required this.address,
    required this.city,
    required this.state,
    this.specialties = const [],
    required this.joinedAt,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.totalProducts = 0,
    this.isVerified = false,
    this.upiId,
    this.bankDetails,
  });

  Artisan copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? shopName,
    String? shopDescription,
    String? address,
    String? city,
    String? state,
    List<String>? specialties,
    DateTime? joinedAt,
    double? rating,
    int? totalOrders,
    int? totalProducts,
    bool? isVerified,
    String? upiId,
    String? bankDetails,
  }) {
    return Artisan(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      shopName: shopName ?? this.shopName,
      shopDescription: shopDescription ?? this.shopDescription,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      specialties: specialties ?? this.specialties,
      joinedAt: joinedAt ?? this.joinedAt,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      totalProducts: totalProducts ?? this.totalProducts,
      isVerified: isVerified ?? this.isVerified,
      upiId: upiId ?? this.upiId,
      bankDetails: bankDetails ?? this.bankDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'shopName': shopName,
      'shopDescription': shopDescription,
      'address': address,
      'city': city,
      'state': state,
      'specialties': specialties,
      'joinedAt': joinedAt.toIso8601String(),
      'rating': rating,
      'totalOrders': totalOrders,
      'totalProducts': totalProducts,
      'isVerified': isVerified,
      'upiId': upiId,
      'bankDetails': bankDetails,
    };
  }

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      shopName: json['shopName'] as String,
      shopDescription: json['shopDescription'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      specialties: List<String>.from(json['specialties'] as Iterable? ?? []),
      joinedAt: _parseDateTime(json['joinedAt']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['totalOrders'] as int?) ?? 0,
      totalProducts: (json['totalProducts'] as int?) ?? 0,
      isVerified: (json['isVerified'] as bool?) ?? false,
      upiId: json['upiId'] as String?,
      bankDetails: json['bankDetails'] as String?,
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
