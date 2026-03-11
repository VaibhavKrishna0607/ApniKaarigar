import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artisan.dart';
import '../services/user_data_provider.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _shopNameController;
  late TextEditingController _shopDescController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _upiController;

  bool _isSaving = false;
  late Artisan? _artisan;

  @override
  void initState() {
    super.initState();
    _artisan = UserDataProvider().currentArtisan;
    _nameController = TextEditingController(text: _artisan?.name ?? '');
    _phoneController = TextEditingController(text: _artisan?.phone ?? '');
    _shopNameController = TextEditingController(text: _artisan?.shopName ?? '');
    _shopDescController = TextEditingController(text: _artisan?.shopDescription ?? '');
    _addressController = TextEditingController(text: _artisan?.address ?? '');
    _cityController = TextEditingController(text: _artisan?.city ?? '');
    _stateController = TextEditingController(text: _artisan?.state ?? '');
    _upiController = TextEditingController(text: _artisan?.upiId ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _shopNameController.dispose();
    _shopDescController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_artisan == null) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('artisans')
          .doc(_artisan!.id)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'shopName': _shopNameController.text.trim(),
        'shopDescription': _shopDescController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'upiId': _upiController.text.trim().isNotEmpty ? _upiController.text.trim() : null,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final artisanName = _artisan?.name ?? 'User';
    final profileImage = _artisan?.profileImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                      backgroundImage: profileImage != null ? NetworkImage(profileImage) : null,
                      child: profileImage == null
                          ? Text(
                              artisanName.isNotEmpty ? artisanName[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  _artisan?.email ?? '',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),

              // Personal Info section
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 10),
              _buildCard(
                children: [
                  _buildField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                  ),
                  _buildDivider(),
                  _buildField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter your phone' : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Shop Info section
              _buildSectionHeader('Shop Information'),
              const SizedBox(height: 10),
              _buildCard(
                children: [
                  _buildField(
                    controller: _shopNameController,
                    label: 'Shop Name',
                    icon: Icons.storefront_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter shop name' : null,
                  ),
                  _buildDivider(),
                  _buildField(
                    controller: _shopDescController,
                    label: 'Shop Description',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address section
              _buildSectionHeader('Location'),
              const SizedBox(height: 10),
              _buildCard(
                children: [
                  _buildField(
                    controller: _addressController,
                    label: 'Street Address',
                    icon: Icons.location_on_outlined,
                  ),
                  _buildDivider(),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _cityController,
                          label: 'City',
                          icon: Icons.location_city_outlined,
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _buildField(
                          controller: _stateController,
                          label: 'State',
                          icon: Icons.map_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment section
              _buildSectionHeader('Payment Details'),
              const SizedBox(height: 10),
              _buildCard(
                children: [
                  _buildField(
                    controller: _upiController,
                    label: 'UPI ID (optional)',
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 54, endIndent: 16);
  }
}
