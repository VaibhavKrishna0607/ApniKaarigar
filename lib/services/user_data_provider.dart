import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/artisan.dart';
import '../models/product.dart';
import '../models/order.dart';
import 'firestore_service.dart';
import 'demo_mode_service.dart';

class UserDataProvider extends ChangeNotifier {
  static final UserDataProvider _instance = UserDataProvider._internal();
  factory UserDataProvider() => _instance;
  UserDataProvider._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final DemoModeService _demoModeService = DemoModeService();

  Artisan? _currentArtisan;
  List<Product> _products = [];
  List<Order> _orders = [];
  bool _isLoading = false;
  bool _isDemoMode = false;

  // Getters
  User? get currentUser => _auth.currentUser;
  Artisan? get currentArtisan => _currentArtisan;
  List<Product> get products => _products;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _auth.currentUser != null;
  bool get isDemoMode => _isDemoMode;

  String get artisanId => _auth.currentUser?.uid ?? 'demo-user';

  // Computed properties
  int get pendingOrdersCount => _orders.where((o) => o.status == OrderStatus.pending).length;
  int get totalOrdersCount => _orders.length;
  double get totalRevenue => _orders
      .where((o) => o.status == OrderStatus.delivered)
      .fold(0.0, (sum, o) => sum + o.totalPrice);
  int get productsCount => _products.length;

  // Initialize user data after login
  Future<void> loadUserData() async {
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Try to load from Firebase with short timeout
      _currentArtisan = await _firestoreService.getArtisan(currentUser!.uid)
          .timeout(const Duration(seconds: 5));

      if (_currentArtisan != null) {
        // Firebase is working, load products and orders
        _products = await _firestoreService.getArtisanProducts(currentUser!.uid)
            .timeout(const Duration(seconds: 5), onTimeout: () => []);

        _orders = await _firestoreService.getArtisanOrders(currentUser!.uid)
            .timeout(const Duration(seconds: 5), onTimeout: () => []);

        _isDemoMode = false;
        debugPrint('User data loaded from Firebase successfully');
      } else {
        // Artisan profile doesn't exist, might be new user
        debugPrint('Artisan profile not found, might be new user');
        _isDemoMode = false;
      }
    } catch (e) {
      debugPrint('Firebase unavailable, enabling demo mode: $e');
      // Firebase is offline or unavailable, use demo mode
      _isDemoMode = true;
      _demoModeService.enableDemoMode(currentUser!.uid);
      _currentArtisan = _demoModeService.getDemoArtisan();
      _products = _demoModeService.getDemoProducts();
      _orders = _demoModeService.getDemoOrders();
      debugPrint('Demo mode enabled with mock data');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    if (currentUser == null) return;
    if (_isDemoMode) {
      _products = _demoModeService.getDemoProducts();
    } else {
      _products = await _firestoreService.getArtisanProducts(currentUser!.uid);
    }
    notifyListeners();
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    if (currentUser == null) return;
    if (_isDemoMode) {
      _orders = _demoModeService.getDemoOrders();
    } else {
      _orders = await _firestoreService.getArtisanOrders(currentUser!.uid);
    }
    notifyListeners();
  }

  // Add product
  Future<String?> addProduct(Product product) async {
    debugPrint('UserDataProvider.addProduct called');
    debugPrint('Current user: ${currentUser?.uid}');
    debugPrint('Is demo mode: $_isDemoMode');
    debugPrint('Product name: ${product.name}');

    try {
      if (_isDemoMode) {
        debugPrint('Adding product in demo mode');
        // Demo mode - add to local list
        _demoModeService.addDemoProduct(product);
        _products = _demoModeService.getDemoProducts();
        notifyListeners();
        debugPrint('Demo product added successfully');
        return product.id;
      }

      debugPrint('Adding product to Firebase');
      // Real Firebase
      final productId = await _firestoreService.createProduct(product, currentUser!.uid);
      debugPrint('Firebase createProduct returned: $productId');

      await refreshProducts();
      debugPrint('Products refreshed, new count: ${_products.length}');

      // Update artisan product count
      if (_currentArtisan != null) {
        debugPrint('Updating artisan product count');
        await _firestoreService.updateArtisanById(_currentArtisan!.id, {
          'totalProducts': _products.length,
        });
      } else {
        debugPrint('Warning: No current artisan found');
      }

      debugPrint('Product added successfully with ID: $productId');
      return productId;
    } catch (e) {
      debugPrint('Error adding product: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // Update product
  Future<bool> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      if (_isDemoMode) {
        // Demo mode - update local list
        final index = _products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          final product = _products[index];
          _products[index] = product.copyWith(
            name: data['name'] as String? ?? product.name,
            description: data['description'] as String? ?? product.description,
            price: (data['price'] as num?)?.toDouble() ?? product.price,
            category: data['category'] as String? ?? product.category,
            stockQuantity: data['stockQuantity'] as int? ?? product.stockQuantity,
            isAvailable: data['isAvailable'] as bool? ?? product.isAvailable,
          );
          notifyListeners();
        }
        return true;
      }

      // Real Firebase
      await _firestoreService.updateProductById(productId, data);
      await refreshProducts();
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      if (_isDemoMode) {
        // Demo mode - remove from local list
        _demoModeService.deleteDemoProduct(productId);
        _products = _demoModeService.getDemoProducts();
        notifyListeners();
        return true;
      }

      // Real Firebase
      await _firestoreService.deleteProduct(productId);
      await refreshProducts();
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      if (_isDemoMode) {
        // Demo mode - update local list
        _demoModeService.updateDemoOrderStatus(orderId, status);
        _orders = _demoModeService.getDemoOrders();
        notifyListeners();
        return true;
      }

      // Real Firebase
      await _firestoreService.updateOrderStatus(orderId, status);
      await refreshOrders();
      return true;
    } catch (e) {
      debugPrint('Error updating order: $e');
      return false;
    }
  }

  // Update artisan profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return false;
    try {
      if (_isDemoMode) {
        // Demo mode - update local artisan
        if (_currentArtisan != null) {
          _currentArtisan = _currentArtisan!.copyWith(
            name: data['name'] as String? ?? _currentArtisan!.name,
            phone: data['phone'] as String? ?? _currentArtisan!.phone,
            shopName: data['shopName'] as String? ?? _currentArtisan!.shopName,
            shopDescription: data['shopDescription'] as String? ?? _currentArtisan!.shopDescription,
            address: data['address'] as String? ?? _currentArtisan!.address,
            city: data['city'] as String? ?? _currentArtisan!.city,
            state: data['state'] as String? ?? _currentArtisan!.state,
          );
          _demoModeService.updateDemoArtisan(_currentArtisan!);
          notifyListeners();
        }
        return true;
      }

      // Real Firebase
      await _firestoreService.updateArtisanById(currentUser!.uid, data);
      _currentArtisan = await _firestoreService.getArtisan(currentUser!.uid);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // Clear data on logout
  void clearData() {
    _currentArtisan = null;
    _products = [];
    _orders = [];
    _isDemoMode = false;
    _demoModeService.disableDemoMode();
    notifyListeners();
  }

  // Categories
  List<String> getCategories() {
    return [
      'All',
      'Woodwork',
      'Pottery',
      'Textile',
      'Metalwork',
      'Jewelry',
      'Paintings',
      'Other',
    ];
  }
}
