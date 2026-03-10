import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/order.dart' as app_models;
import '../models/artisan.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;

  FirestoreService._internal() {
    _initializeFirestore();
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _initializeFirestore() {
    if (kIsWeb) {
      // Enable persistence for web
      _db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }
  }

  // Collection references
  CollectionReference<Map<String, dynamic>> get _artisansCollection =>
      _db.collection('artisans');

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _db.collection('products');

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _db.collection('orders');

  // ==================== ARTISAN OPERATIONS ====================

  // Create artisan profile
  Future<void> createArtisan(Artisan artisan) async {
    await _artisansCollection.doc(artisan.id).set(artisan.toJson());
  }

  // Get artisan by ID
  Future<Artisan?> getArtisan(String artisanId) async {
    try {
      final doc = await _artisansCollection.doc(artisanId).get();
      if (doc.exists && doc.data() != null) {
        return Artisan.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      debugPrint('Error getting artisan: $e');
      return null;
    }
  }

  // Update artisan profile
  Future<void> updateArtisan(Artisan artisan) async {
    await _artisansCollection.doc(artisan.id).update(artisan.toJson());
  }

  // Update artisan profile by ID with data map
  Future<void> updateArtisanById(String artisanId, Map<String, dynamic> data) async {
    await _artisansCollection.doc(artisanId).update(data);
  }

  // Stream artisan data
  Stream<Artisan?> streamArtisan(String artisanId) {
    return _artisansCollection.doc(artisanId).snapshots().map((doc) {
      if (doc.exists) {
        return Artisan.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }

  // ==================== PRODUCT OPERATIONS ====================

  // Create product
  Future<String> createProduct(Product product, String artisanId) async {
    debugPrint('FirestoreService.createProduct called');
    debugPrint('Product: ${product.name}');
    debugPrint('Artisan ID: $artisanId');

    try {
      final productData = {
        ...product.toJson(),
        'artisanId': artisanId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      debugPrint('Product data prepared: ${productData.keys.toList()}');

      final docRef = await _productsCollection.add(productData);
      debugPrint('Product created with ID: ${docRef.id}');

      return docRef.id;
    } catch (e) {
      debugPrint('Error in createProduct: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  // Get product by ID
  Future<Product?> getProduct(String productId) async {
    final doc = await _productsCollection.doc(productId).get();
    if (doc.exists) {
      return Product.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    await _productsCollection.doc(product.id).update({
      ...product.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update product by ID with data map
  Future<void> updateProductById(String productId, Map<String, dynamic> data) async {
    await _productsCollection.doc(productId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }

  // Get all products for an artisan (for artisan management)
  Future<List<Product>> getArtisanProducts(String artisanId) async {
    try {
      final query = await _productsCollection
          .where('artisanId', isEqualTo: artisanId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting artisan products: $e');
      return [];
    }
  }

  // Get ALL products for marketplace (for customers)
  Future<List<Product>> getAllProducts() async {
    final query = await _productsCollection
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return query.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Fallback method when index is not ready
  Future<List<Product>> getAllProductsFallback() async {
    debugPrint('Using fallback method to get products...');
    final query = await _productsCollection
        .limit(100)
        .get();

    final products = query.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .where((product) => product.isAvailable)
        .toList();

    // Sort in memory
    products.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return products;
  }

  // Get products by category for marketplace
  Future<List<Product>> getAllProductsByCategory(String category) async {
    try {
      final query = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return query.docs
          .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting products by category: $e');
      return [];
    }
  }

  // Search products by name/description for marketplace
  Future<List<Product>> searchProducts(String searchTerm) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation - for production, use Algolia or similar
      final query = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      final allProducts = query.docs
          .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter by search term
      return allProducts.where((product) {
        final searchLower = searchTerm.toLowerCase();
        return product.name.toLowerCase().contains(searchLower) ||
               product.description.toLowerCase().contains(searchLower) ||
               product.tags.any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();
    } catch (e) {
      debugPrint('Error searching products: $e');
      return [];
    }
  }

  // Stream products for an artisan
  Stream<List<Product>> streamArtisanProducts(String artisanId) {
    return _productsCollection
        .where('artisanId', isEqualTo: artisanId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Search products by category
  Future<List<Product>> getProductsByCategory(String artisanId, String category) async {
    final query = await _productsCollection
        .where('artisanId', isEqualTo: artisanId)
        .where('category', isEqualTo: category)
        .get();

    return query.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Update product stock
  Future<void> updateProductStock(String productId, int newQuantity) async {
    await _productsCollection.doc(productId).update({
      'stockQuantity': newQuantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== ORDER OPERATIONS ====================

  // Create order
  Future<String> createOrder(app_models.Order order) async {
    final docRef = await _ordersCollection.add({
      ...order.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Create customer order (when customer places order)
  Future<String> createCustomerOrder({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required String artisanId,
    required String productId,
    required String productName,
    required double productPrice,
    required int quantity,
    required double totalPrice,
    String? specialInstructions,
  }) async {
    // Get current product to check stock
    final product = await getProduct(productId);
    if (product == null) {
      throw Exception('Product not found');
    }

    // Check if enough stock is available
    if (product.stockQuantity < quantity) {
      throw Exception('Insufficient stock. Only ${product.stockQuantity} items available.');
    }

    final order = app_models.Order(
      id: '', // Will be set by Firestore
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      artisanId: artisanId,
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      quantity: quantity,
      totalPrice: totalPrice,
      status: app_models.OrderStatus.pending,
      createdAt: DateTime.now(),
      specialInstructions: specialInstructions,
    );

    final docRef = await _ordersCollection.add({
      ...order.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update product stock - decrement by quantity ordered
    final newStock = product.stockQuantity - quantity;
    await updateProductStock(productId, newStock);

    debugPrint('Order created and stock updated: $productId, new stock: $newStock');

    return docRef.id;
  }

  // Get order by ID
  Future<app_models.Order?> getOrder(String orderId) async {
    final doc = await _ordersCollection.doc(orderId).get();
    if (doc.exists) {
      return app_models.Order.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, app_models.OrderStatus status) async {
    await _ordersCollection.doc(orderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all orders for an artisan
  Future<List<app_models.Order>> getArtisanOrders(String artisanId) async {
    try {
      final query = await _ordersCollection
          .where('artisanId', isEqualTo: artisanId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => app_models.Order.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting artisan orders: $e');
      return [];
    }
  }

  // Stream orders for an artisan
  Stream<List<app_models.Order>> streamArtisanOrders(String artisanId) {
    return _ordersCollection
        .where('artisanId', isEqualTo: artisanId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => app_models.Order.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get orders by status
  Future<List<app_models.Order>> getOrdersByStatus(String artisanId, app_models.OrderStatus status) async {
    final query = await _ordersCollection
        .where('artisanId', isEqualTo: artisanId)
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs
        .map((doc) => app_models.Order.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Get customer orders (for customers to see their orders)
  Future<List<app_models.Order>> getCustomerOrders(String customerId) async {
    try {
      final query = await _ordersCollection
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => app_models.Order.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting customer orders: $e');
      return [];
    }
  }

  // Get pending orders count
  Future<int> getPendingOrdersCount(String artisanId) async {
    final query = await _ordersCollection
        .where('artisanId', isEqualTo: artisanId)
        .where('status', isEqualTo: 'pending')
        .count()
        .get();

    return query.count ?? 0;
  }

  // ==================== ANALYTICS OPERATIONS ====================

  // Get total revenue
  Future<double> getTotalRevenue(String artisanId) async {
    final query = await _ordersCollection
        .where('artisanId', isEqualTo: artisanId)
        .where('status', isEqualTo: 'delivered')
        .get();

    double total = 0;
    for (var doc in query.docs) {
      total += (doc.data()['totalPrice'] as num?)?.toDouble() ?? 0;
    }
    return total;
  }

  // Get order count by status
  Future<Map<String, int>> getOrderCountsByStatus(String artisanId) async {
    final query = await _ordersCollection
        .where('artisanId', isEqualTo: artisanId)
        .get();

    final counts = <String, int>{};
    for (var doc in query.docs) {
      final status = doc.data()['status'] as String? ?? 'unknown';
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }
}
