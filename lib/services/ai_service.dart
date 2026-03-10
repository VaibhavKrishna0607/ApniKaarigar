/// AI Service for generating content and suggestions
/// Note: In production, this would connect to actual AI APIs (OpenAI, Google AI, etc.)
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  /// Generate product description using AI
  Future<String> generateProductDescription({
    required String productName,
    required String category,
    String? material,
    String? additionalInfo,
  }) async {
    // Simulate API delay
    await Future<void>.delayed(const Duration(seconds: 2));
    
    // In production, this would call an AI API
    final descriptions = {
      'Woodwork': 'This exquisite $productName showcases the finest traditions of Indian woodcraft. '
          'Meticulously hand-carved by skilled artisans, each piece tells a story of heritage and dedication. '
          '${material != null ? "Crafted from premium $material, " : ""}'
          'this masterpiece combines traditional techniques with timeless design, making it a perfect addition to any collection. '
          '${additionalInfo ?? ""}',
      'Pottery': 'Embrace the beauty of traditional Indian pottery with this stunning $productName. '
          'Hand-shaped and painted with care, this piece reflects centuries-old techniques passed down through generations. '
          '${material != null ? "Made with authentic $material, " : ""}'
          'it brings warmth and character to any space. ${additionalInfo ?? ""}',
      'Textile': 'This handcrafted $productName represents the rich textile heritage of India. '
          'Woven with precision and dyed using traditional methods, each thread tells a story. '
          '${material != null ? "Featuring premium $material, " : ""}'
          'this piece adds authentic charm to your home. ${additionalInfo ?? ""}',
      'Metalwork': 'Discover the artistry of Indian metalwork with this beautiful $productName. '
          'Handcrafted by master artisans using time-honored techniques, this piece embodies elegance and craftsmanship. '
          '${material != null ? "Made from high-quality $material, " : ""}'
          'it serves as both a functional item and a work of art. ${additionalInfo ?? ""}',
    };
    
    return descriptions[category] ?? 
        'Introducing this beautiful $productName, lovingly handcrafted by skilled artisans. '
        'Each piece is unique, showcasing traditional craftsmanship and attention to detail. '
        '${material != null ? "Made with $material, " : ""}'
        'this item makes a perfect gift or addition to your collection. ${additionalInfo ?? ""}';
  }

  /// Generate marketing content for social media
  Future<Map<String, String>> generateMarketingContent({
    required String productName,
    required double price,
    required String category,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    
    return {
      'instagram': '✨ New Arrival! ✨\n\n'
          'Introducing our beautiful $productName - a masterpiece of $category craftsmanship! 🎨\n\n'
          '💰 Price: ₹${price.toStringAsFixed(0)}\n\n'
          '🛒 DM to order or visit our store\n\n'
          '#Handmade #IndianArtisan #TraditionalCraft #SupportLocal #ApnaKaarigar',
      
      'whatsapp': '🙏 Namaste!\n\n'
          'Check out our latest creation:\n\n'
          '✨ *$productName*\n'
          '📦 Category: $category\n'
          '💰 Price: ₹${price.toStringAsFixed(0)}\n\n'
          '100% Handcrafted with love! 🎨\n\n'
          'Reply to this message to place your order! 🛒',
      
      'facebook': '🎉 Exciting New Product Alert! 🎉\n\n'
          'We are thrilled to present our latest $category masterpiece - $productName!\n\n'
          'Price: ₹${price.toStringAsFixed(0)}\n\n'
          '👆 Each piece is lovingly handcrafted by our skilled artisans, ensuring you receive a unique work of art.\n\n'
          '📱 Comment "INTERESTED" or send us a message to order!\n\n'
          '#MadeInIndia #Handcrafted #SupportArtisans #TraditionalArt',
    };
  }

  /// Suggest pricing based on category, material, and complexity
  Future<Map<String, dynamic>> suggestPricing({
    required String category,
    required String material,
    required int hoursToMake,
    required double materialCost,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Base hourly rate for artisan work
    const double hourlyRate = 150;
    
    // Category multipliers
    final categoryMultipliers = {
      'Woodwork': 1.2,
      'Pottery': 1.0,
      'Textile': 1.1,
      'Metalwork': 1.3,
      'Jewelry': 1.5,
      'Leather': 1.2,
      'Paintings': 1.4,
    };
    
    final multiplier = categoryMultipliers[category] ?? 1.0;
    final laborCost = hoursToMake * hourlyRate * multiplier;
    final basePrice = materialCost + laborCost;
    
    // Calculate suggested prices with different margins
    return {
      'costPrice': basePrice,
      'economyPrice': basePrice * 1.3, // 30% margin
      'recommendedPrice': basePrice * 1.5, // 50% margin
      'premiumPrice': basePrice * 2.0, // 100% margin
      'breakdown': {
        'materialCost': materialCost,
        'laborCost': laborCost,
        'hourlyRate': hourlyRate * multiplier,
      },
      'tips': [
        'Consider the uniqueness of your work when pricing',
        'Premium pricing works well for one-of-a-kind pieces',
        'Bundle products for better value perception',
      ],
    };
  }

  /// Generate product tags/keywords
  Future<List<String>> generateTags({
    required String productName,
    required String category,
    required String description,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    final baseTags = ['handmade', 'artisan', 'indian', 'traditional', 'handcrafted'];
    
    final categoryTags = {
      'Woodwork': ['wooden', 'carved', 'teak', 'sustainable'],
      'Pottery': ['ceramic', 'clay', 'earthenware', 'handpainted'],
      'Textile': ['fabric', 'woven', 'cotton', 'natural dye'],
      'Metalwork': ['brass', 'copper', 'metal art', 'decorative'],
      'Jewelry': ['ethnic', 'silver', 'statement', 'boho'],
      'Leather': ['genuine leather', 'handstitched', 'durable'],
      'Paintings': ['art', 'canvas', 'folk art', 'miniature'],
    };
    
    final tags = <String>{...baseTags, ...?categoryTags[category]};
    
    // Add name-based tags
    final nameWords = productName.toLowerCase().split(' ');
    for (final word in nameWords) {
      if (word.length > 3) {
        tags.add(word);
      }
    }
    
    return tags.toList();
  }

  /// Analyze product image and suggest improvements (mock)
  Future<Map<String, dynamic>> analyzeProductImage(String imagePath) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    
    return {
      'qualityScore': 85,
      'suggestions': [
        'Consider using natural lighting for better colors',
        'Try capturing from multiple angles',
        'A plain background would make the product stand out',
        'Adding a scale reference helps buyers understand size',
      ],
      'detectedColors': ['brown', 'gold', 'cream'],
      'suggestedCategories': ['Woodwork', 'Home Decor'],
    };
  }

  /// Chat assistant response
  Future<String> getChatResponse(String userMessage) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    final lowercaseMessage = userMessage.toLowerCase();
    
    if (lowercaseMessage.contains('price') || lowercaseMessage.contains('pricing')) {
      return 'For pricing your handcrafted items, I recommend:\n\n'
          '1. Calculate material cost\n'
          '2. Add labor cost (₹100-200/hour)\n'
          '3. Add 30-50% profit margin\n'
          '4. Consider uniqueness premium\n\n'
          'Would you like me to help calculate pricing for a specific product?';
    }
    
    if (lowercaseMessage.contains('ship') || lowercaseMessage.contains('delivery')) {
      return 'For shipping handcrafted items:\n\n'
          '• Use proper cushioning materials\n'
          '• Double-box fragile items\n'
          '• Add insurance for valuable pieces\n'
          '• Provide tracking to customers\n\n'
          'Popular couriers: India Post (economical), DTDC, Delhivery, BlueDart (premium)';
    }
    
    if (lowercaseMessage.contains('market') || lowercaseMessage.contains('promote') || lowercaseMessage.contains('sell')) {
      return 'To market your products effectively:\n\n'
          '📱 Social Media:\n'
          '• Post high-quality photos\n'
          '• Share behind-the-scenes content\n'
          '• Use relevant hashtags\n\n'
          '🤝 Local:\n'
          '• Participate in craft fairs\n'
          '• Partner with local stores\n\n'
          '💡 Need help creating social media posts? I can generate them for you!';
    }
    
    if (lowercaseMessage.contains('hello') || lowercaseMessage.contains('hi') || lowercaseMessage.contains('help')) {
      return 'Namaste! 🙏 I\'m your AI assistant for ApnaKaarigar.\n\n'
          'I can help you with:\n'
          '• 📝 Product descriptions\n'
          '• 💰 Pricing suggestions\n'
          '• 📣 Marketing content\n'
          '• 🏷️ Product tags\n'
          '• 📦 Shipping advice\n\n'
          'What would you like help with today?';
    }
    
    return 'I understand you\'re asking about "${userMessage.length > 30 ? '${userMessage.substring(0, 30)}...' : userMessage}". '
        'As your AI assistant, I can help with product descriptions, pricing, marketing, and more. '
        'Could you please provide more details about what you need help with?';
  }

  /// Generate catalog/brochure content
  Future<String> generateCatalogContent({
    required String shopName,
    required List<String> productNames,
    required String specialty,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    
    return '''
$shopName
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎨 Our Story
Welcome to $shopName, where tradition meets artistry. We specialize in $specialty, carrying forward the legacy of Indian craftsmanship.

✨ Featured Products
${productNames.map((p) => '• $p').join('\n')}

🏆 Why Choose Us?
• 100% Handcrafted with love
• Authentic traditional techniques
• Sustainable materials
• Direct from artisan to you
• Custom orders welcome

📞 Contact Us
Ready to own a piece of Indian heritage? Reach out to us today!

#MadeWithLove #SupportLocal #ApnaKaarigar
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''';
  }
}
