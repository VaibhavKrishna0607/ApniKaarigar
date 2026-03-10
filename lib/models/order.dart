import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String customerId; // Added for marketplace
  final String customerName; // Renamed from buyerName
  final String customerPhone; // Renamed from buyerPhone
  final String customerAddress; // Renamed from buyerAddress
  final String artisanId;
  final String productId;
  final String productName;
  final String? productImage;
  final double productPrice; // Added individual product price
  final int quantity;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt; // Renamed from orderedAt
  final DateTime? deliveredAt;
  final String? specialInstructions; // Renamed from notes

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.artisanId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    this.specialInstructions,
  });

  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? artisanId,
    String? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    int? quantity,
    double? totalPrice,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? specialInstructions,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      artisanId: artisanId ?? this.artisanId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  // Legacy getters for backward compatibility
  String get buyerName => customerName;
  String get buyerPhone => customerPhone;
  String get buyerAddress => customerAddress;
  DateTime get orderedAt => createdAt;
  String? get notes => specialInstructions;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'artisanId': artisanId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'specialInstructions': specialInstructions,
      // Legacy fields for backward compatibility
      'buyerName': customerName,
      'buyerPhone': customerPhone,
      'buyerAddress': customerAddress,
      'orderedAt': createdAt.toIso8601String(),
      'notes': specialInstructions,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id'] as String?) ?? '',
      customerId: (json['customerId'] as String?) ?? (json['buyerId'] as String?) ?? '', // Handle legacy field
      customerName: (json['customerName'] as String?) ?? (json['buyerName'] as String?) ?? '',
      customerPhone: (json['customerPhone'] as String?) ?? (json['buyerPhone'] as String?) ?? '',
      customerAddress: (json['customerAddress'] as String?) ?? (json['buyerAddress'] as String?) ?? '',
      artisanId: (json['artisanId'] as String?) ?? '',
      productId: (json['productId'] as String?) ?? '',
      productName: (json['productName'] as String?) ?? '',
      productImage: json['productImage'] as String?,
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as int?) ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: _parseOrderStatus(json['status']),
      createdAt: _parseDateTime(json['createdAt'] ?? json['orderedAt']),
      deliveredAt: json['deliveredAt'] != null
          ? _parseDateTime(json['deliveredAt'])
          : null,
      specialInstructions: (json['specialInstructions'] as String?) ?? (json['notes'] as String?),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  static OrderStatus _parseOrderStatus(dynamic status) {
    if (status is String) {
      return OrderStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => OrderStatus.pending,
      );
    } else if (status is int) {
      return OrderStatus.values[status];
    }
    return OrderStatus.pending;
  }
}
