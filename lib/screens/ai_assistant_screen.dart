import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ai_service.dart';
import '../services/mock_data_service.dart';
import '../theme/app_theme.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final AIService _aiService = AIService();
  final MockDataService _dataService = MockDataService();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: 'Namaste! 🙏 I\'m your AI assistant for ApnaKaarigar.\n\n'
          'I can help you with:\n'
          '• 📝 Product descriptions\n'
          '• 💰 Pricing suggestions\n'
          '• 📣 Marketing content\n'
          '• 🏷️ Product tags\n'
          '• 📦 Shipping advice\n\n'
          'What would you like help with today?',
      isUser: false,
    ));
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _chatController.clear();
    });

    _scrollToBottom();

    final response = await _aiService.getChatResponse(text);

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 24),
            SizedBox(width: 8),
            Text('AI Assistant'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleQuickAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'description',
                child: ListTile(
                  leading: Icon(Icons.description, color: AppTheme.primaryColor),
                  title: Text('Generate Description'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'marketing',
                child: ListTile(
                  leading: Icon(Icons.campaign, color: AppTheme.accentColor),
                  title: Text('Create Marketing Post'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'pricing',
                child: ListTile(
                  leading: Icon(Icons.currency_rupee, color: AppTheme.successColor),
                  title: Text('Pricing Assistant'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'catalog',
                child: ListTile(
                  leading: Icon(Icons.menu_book, color: AppTheme.infoColor),
                  title: Text('Generate Catalog'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick action chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildQuickChip('📝 Describe Product', () => _handleQuickAction('description')),
                  _buildQuickChip('💰 Price Help', () => _handleQuickAction('pricing')),
                  _buildQuickChip('📣 Marketing', () => _handleQuickAction('marketing')),
                  _buildQuickChip('📦 Shipping Tips', () => _quickAsk('How should I ship fragile items?')),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        filled: true,
                        fillColor: AppTheme.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: AppTheme.backgroundColor,
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.isUser ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : AppTheme.textPrimary,
                fontSize: 15,
              ),
            ),
            if (!message.isUser) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.copy, size: 16, color: AppTheme.textLight),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.textLight.withValues(alpha: 0.5 + (value * 0.5)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'description':
        _showDescriptionGenerator();
        break;
      case 'marketing':
        _showMarketingGenerator();
        break;
      case 'pricing':
        _showPricingAssistant();
        break;
      case 'catalog':
        _showCatalogGenerator();
        break;
    }
  }

  void _quickAsk(String question) {
    _chatController.text = question;
    _sendMessage();
  }

  void _showDescriptionGenerator() {
    final nameController = TextEditingController();
    String selectedCategory = 'Woodwork';
    final materialController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.accentColor),
                      SizedBox(width: 8),
                      Text(
                        'AI Description Generator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'e.g., Hand-carved Wooden Elephant',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _dataService.getCategories()
                        .where((c) => c != 'All')
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => selectedCategory = value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: materialController,
                    decoration: const InputDecoration(
                      labelText: 'Material (optional)',
                      hintText: 'e.g., Teak wood, Brass, Cotton',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (nameController.text.isEmpty) return;
                        Navigator.pop(context);
                        
                        setState(() => _isLoading = true);
                        _messages.add(ChatMessage(
                          text: 'Generate a description for: ${nameController.text} (${selectedCategory})',
                          isUser: true,
                        ));
                        
                        final desc = await _aiService.generateProductDescription(
                          productName: nameController.text,
                          category: selectedCategory,
                          material: materialController.text.isNotEmpty ? materialController.text : null,
                        );
                        
                        setState(() {
                          _messages.add(ChatMessage(
                            text: '✨ Here\'s your AI-generated description:\n\n$desc',
                            isUser: false,
                          ));
                          _isLoading = false;
                        });
                        _scrollToBottom();
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Description'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMarketingGenerator() {
    final products = _dataService.getProducts();
    String? selectedProductId = products.isNotEmpty ? products.first.id : null;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.campaign, color: AppTheme.accentColor),
                      SizedBox(width: 8),
                      Text(
                        'Marketing Content Generator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Generate social media posts for your products',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedProductId,
                    decoration: const InputDecoration(labelText: 'Select Product'),
                    items: products
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => selectedProductId = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (selectedProductId == null) return;
                        Navigator.pop(context);
                        
                        final product = products.firstWhere((p) => p.id == selectedProductId);
                        
                        setState(() => _isLoading = true);
                        _messages.add(ChatMessage(
                          text: 'Create marketing posts for: ${product.name}',
                          isUser: true,
                        ));
                        
                        final content = await _aiService.generateMarketingContent(
                          productName: product.name,
                          price: product.price,
                          category: product.category,
                        );
                        
                        setState(() {
                          _messages.add(ChatMessage(
                            text: '📣 Here are your marketing posts:\n\n'
                                '━━━ Instagram ━━━\n${content['instagram']}\n\n'
                                '━━━ WhatsApp ━━━\n${content['whatsapp']}\n\n'
                                '━━━ Facebook ━━━\n${content['facebook']}',
                            isUser: false,
                          ));
                          _isLoading = false;
                        });
                        _scrollToBottom();
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Posts'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPricingAssistant() {
    final materialCostController = TextEditingController();
    final hoursController = TextEditingController();
    String selectedCategory = 'Woodwork';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.currency_rupee, color: AppTheme.successColor),
                      SizedBox(width: 8),
                      Text(
                        'Pricing Assistant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get AI-powered pricing suggestions',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _dataService.getCategories()
                        .where((c) => c != 'All')
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => selectedCategory = value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: materialCostController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Material Cost (₹)',
                      hintText: 'e.g., 500',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hours to Make',
                      hintText: 'e.g., 8',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (materialCostController.text.isEmpty || hoursController.text.isEmpty) return;
                        Navigator.pop(context);
                        
                        final materialCost = double.tryParse(materialCostController.text) ?? 0;
                        final hours = int.tryParse(hoursController.text) ?? 0;
                        
                        setState(() => _isLoading = true);
                        _messages.add(ChatMessage(
                          text: 'Calculate pricing for $selectedCategory - Material: ₹$materialCost, Hours: $hours',
                          isUser: true,
                        ));
                        
                        final pricing = await _aiService.suggestPricing(
                          category: selectedCategory,
                          material: selectedCategory,
                          hoursToMake: hours,
                          materialCost: materialCost,
                        );
                        
                        setState(() {
                          _messages.add(ChatMessage(
                            text: '💰 Pricing Suggestions:\n\n'
                                '📊 Cost Breakdown:\n'
                                '• Material: ₹${pricing['breakdown']['materialCost'].toStringAsFixed(0)}\n'
                                '• Labor: ₹${pricing['breakdown']['laborCost'].toStringAsFixed(0)}\n'
                                '• Total Cost: ₹${pricing['costPrice'].toStringAsFixed(0)}\n\n'
                                '🏷️ Suggested Prices:\n'
                                '• Economy (30% margin): ₹${pricing['economyPrice'].toStringAsFixed(0)}\n'
                                '• Recommended (50%): ₹${pricing['recommendedPrice'].toStringAsFixed(0)} ⭐\n'
                                '• Premium (100%): ₹${pricing['premiumPrice'].toStringAsFixed(0)}\n\n'
                                '💡 Tips:\n${(pricing['tips'] as List).map((t) => '• $t').join('\n')}',
                            isUser: false,
                          ));
                          _isLoading = false;
                        });
                        _scrollToBottom();
                      },
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate Price'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCatalogGenerator() async {
    final artisan = _dataService.currentArtisan;
    final products = _dataService.getProducts();

    setState(() => _isLoading = true);
    _messages.add(ChatMessage(
      text: 'Generate a catalog for my shop',
      isUser: true,
    ));

    final catalog = await _aiService.generateCatalogContent(
      shopName: artisan.shopName,
      productNames: products.map((p) => p.name).take(5).toList(),
      specialty: artisan.specialties.join(', '),
    );

    setState(() {
      _messages.add(ChatMessage(
        text: '📖 Here\'s your digital catalog:\n\n$catalog',
        isUser: false,
      ));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
