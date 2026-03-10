import 'package:flutter/foundation.dart';
import '../models/artisan.dart';
import '../models/product.dart';
import '../models/order.dart';

/// Demo mode service - provides mock data when Firebase is unavailable
class DemoModeService {
  static final DemoModeService _instance = DemoModeService._internal();
  factory DemoModeService() => _instance;
  DemoModeService._internal();

  bool _isDemoMode = false;
  bool get isDemoMode => _isDemoMode;

  Artisan? _demoArtisan;
  List<Product> _demoProducts = [];
  List<Order> _demoOrders = [];

  void enableDemoMode(String userId) {
    _isDemoMode = true;
    _initializeDemoData(userId);
    debugPrint('Demo mode enabled - using mock data');
  }

  void disableDemoMode() {
    _isDemoMode = false;
    _demoArtisan = null;
    _demoProducts = [];
    _demoOrders = [];
  }

  void _initializeDemoData(String userId) {
    // Create demo artisan
    _demoArtisan = Artisan(
      id: userId,
      name: 'Demo Artisan',
      email: 'demo@apnakaarigar.com',
      phone: '+91 9876543210',
      shopName: 'Demo Handicrafts',
      shopDescription: 'Traditional Indian handicrafts made with love',
      address: '123 Craft Street',
      city: 'Mumbai',
      state: 'Maharashtra',
      specialties: ['Woodwork', 'Pottery', 'Textile'],
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      rating: 4.5,
      totalOrders: 15,
      totalProducts: 5,
      isVerified: true,
    );

    // Create demo products
    _demoProducts = [
      Product(
        id: 'demo-product-1',
        name: 'Handcrafted Wooden Bowl',
        description: 'Beautiful wooden bowl carved from premium teak wood',
        price: 1500.0,
        category: 'Woodwork',
        images: ['https://via.placeholder.com/400x400?text=Wooden+Bowl'],
        artisanId: userId,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        stockQuantity: 10,
        isAvailable: true,
        tags: ['handmade', 'wooden', 'bowl', 'teak'],
        rating: 4.8,
        reviewCount: 12,
      ),
      Product(
        id: 'demo-product-2',
        name: 'Clay Pottery Set',
        description: 'Traditional clay pottery set with beautiful designs',
        price: 2500.0,
        category: 'Pottery',
        images: ['https://via.placeholder.com/400x400?text=Pottery+Set'],
        artisanId: userId,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        stockQuantity: 5,
        isAvailable: true,
        tags: ['handmade', 'pottery', 'clay', 'traditional'],
        rating: 4.6,
        reviewCount: 8,
      ),
      Product(
        id: 'demo-product-3',
        name: 'Handwoven Textile',
        description: 'Beautiful handwoven textile with traditional patterns',
        price: 3500.0,
        category: 'Textile',
        images: ['https://via.placeholder.com/400x400?text=Textile'],
        artisanId: userId,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        stockQuantity: 8,
        isAvailable: true,
        tags: ['handmade', 'textile', 'woven', 'traditional'],
        rating: 4.9,
        reviewCount: 15,
      ),
    ];

    // Create demo orders
    _demoOrders = [
      Order(
        id: 'demo-order-1',
        customerId: 'demo-customer-1',
        productId: 'demo-product-1',
        productName: 'Handcrafted Wooden Bowl',
        productImage: 'https://via.placeholder.com/400x400?text=Wooden+Bowl',
        customerName: 'Rajesh Kumar',
        customerPhone: '+91 9876543211',
        customerAddress: '456 Customer Street, Delhi',
        productPrice: 1500.0,
        quantity: 2,
        totalPrice: 3000.0,
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        artisanId: userId,
      ),
      Order(
        id: 'demo-order-2',
        customerId: 'demo-customer-2',
        productId: 'demo-product-2',
        productName: 'Clay Pottery Set',
        productImage: 'https://via.placeholder.com/400x400?text=Pottery+Set',
        customerName: 'Priya Sharma',
        customerPhone: '+91 9876543212',
        customerAddress: '789 Buyer Lane, Bangalore',
        productPrice: 2500.0,
        quantity: 1,
        totalPrice: 2500.0,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        artisanId: userId,
      ),
      Order(
        id: 'demo-order-3',
        customerId: 'demo-customer-3',
        productId: 'demo-product-3',
        productName: 'Handwoven Textile',
        productImage: 'https://via.placeholder.com/400x400?text=Textile',
        customerName: 'Amit Patel',
        customerPhone: '+91 9876543213',
        customerAddress: '321 Order Road, Pune',
        productPrice: 3500.0,
        quantity: 1,
        totalPrice: 3500.0,
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 2)),
        artisanId: userId,
      ),
    ];
  }

  Artisan? getDemoArtisan() => _demoArtisan;
  List<Product> getDemoProducts() => List.from(_demoProducts);
  List<Order> getDemoOrders() => List.from(_demoOrders);

  void addDemoProduct(Product product) {
    _demoProducts.add(product.copyWith(
      id: 'demo-product-${DateTime.now().millisecondsSinceEpoch}',
    ));
  }

  void updateDemoProduct(String productId, Product product) {
    final index = _demoProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _demoProducts[index] = product;
    }
  }

  void deleteDemoProduct(String productId) {
    _demoProducts.removeWhere((p) => p.id == productId);
  }

  void updateDemoOrderStatus(String orderId, OrderStatus status) {
    final index = _demoOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _demoOrders[index] = _demoOrders[index].copyWith(status: status);
    }
  }

  void updateDemoArtisan(Artisan artisan) {
    _demoArtisan = artisan;
  }
}
