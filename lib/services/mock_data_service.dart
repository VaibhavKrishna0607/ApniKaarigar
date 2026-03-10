import '../models/product.dart';
import '../models/order.dart';
import '../models/artisan.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Empty artisan - will be replaced with Firebase data after login
  final Artisan currentArtisan = Artisan(
    id: '',
    name: 'Guest User',
    email: '',
    phone: '',
    profileImage: null,
    shopName: 'My Shop',
    shopDescription: 'Welcome to my shop',
    address: '',
    city: '',
    state: '',
    specialties: [],
    joinedAt: DateTime.now(),
    rating: 0.0,
    totalOrders: 0,
    totalProducts: 0,
    isVerified: false,
    upiId: null,
  );

  // Empty products - will be fetched from Firebase
  List<Product> getProducts() {
    return [];
  }

  // Empty orders - will be fetched from Firebase
  List<Order> getOrders() {
    return [];
  }

  // Categories available
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
