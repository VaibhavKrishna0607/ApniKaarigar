import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/artisan.dart';
import 'firestore_service.dart';

class MarketplaceService extends ChangeNotifier {
  static final MarketplaceService _instance = MarketplaceService._internal();
  factory MarketplaceService() => _instance;
  MarketplaceService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Order> _customerOrders = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Order> get customerOrders => _customerOrders;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  User? get currentUser => _auth.currentUser;

  // Load all products for marketplace
  Future<void> loadAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Loading all products for marketplace...');
      _allProducts = await _firestoreService.getAllProducts();
      debugPrint('Loaded ${_allProducts.length} products');
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading all products: $e');
      // Fallback: try to get some products without the index
      try {
        debugPrint('Trying fallback method...');
        _allProducts = await _firestoreService.getAllProductsFallback();
        debugPrint('Fallback loaded ${_allProducts.length} products');
        _applyFilters();
      } catch (fallbackError) {
        debugPrint('Fallback also failed: $fallbackError');
        _allProducts = [];
        _filteredProducts = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter products by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Apply filters and search
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Category filter
      final matchesCategory = _selectedCategory == 'All' ||
                             product.category == _selectedCategory;

      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
                           product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch && product.isAvailable;
    }).toList();

    notifyListeners();
  }

  // Get product by ID
  Future<Product?> getProduct(String productId) async {
    return await _firestoreService.getProduct(productId);
  }

  // Get artisan info for a product
  Future<Artisan?> getArtisan(String artisanId) async {
    return await _firestoreService.getArtisan(artisanId);
  }

  // Place order
  Future<String?> placeOrder({
    required String productId,
    required String productName,
    required double productPrice,
    required String artisanId,
    required int quantity,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    String? specialInstructions,
  }) async {
    if (currentUser == null) {
      debugPrint('User not logged in');
      return null;
    }

    try {
      final totalPrice = productPrice * quantity;

      final orderId = await _firestoreService.createCustomerOrder(
        customerId: currentUser!.uid,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        artisanId: artisanId,
        productId: productId,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        totalPrice: totalPrice,
        specialInstructions: specialInstructions,
      );

      // Refresh customer orders
      await loadCustomerOrders();

      return orderId;
    } catch (e) {
      debugPrint('Error placing order: $e');
      return null;
    }
  }

  // Load customer's orders
  Future<void> loadCustomerOrders() async {
    if (currentUser == null) return;

    try {
      // Get orders where customer is the current user
      _customerOrders = await _firestoreService.getCustomerOrders(currentUser!.uid);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading customer orders: $e');
    }
  }

  // Get categories
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

  // Clear data
  void clearData() {
    _allProducts = [];
    _filteredProducts = [];
    _customerOrders = [];
    _selectedCategory = 'All';
    _searchQuery = '';
    notifyListeners();
  }
}