import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomPaint(
          painter: CraftPatternPainter(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                _buildLogo(),
                
                const SizedBox(height: 48),
                
                // Title
                const Text(
                  'How would you like to use\nApnaKaarigar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Role Cards
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRoleCard(
                        role: 'buyer',
                        title: 'Buyer',
                        icon: Icons.shopping_bag_outlined,
                        description: 'Discover unique handmade products\nfrom Indian artisans',
                        isSelected: _selectedRole == 'buyer',
                        onTap: () => setState(() => _selectedRole = 'buyer'),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      _buildRoleCard(
                        role: 'seller',
                        title: 'Seller / Artisan',
                        icon: Icons.handyman_outlined,
                        description: 'Showcase and sell your\nhandmade creations',
                        isSelected: _selectedRole == 'seller',
                        onTap: () => setState(() => _selectedRole = 'seller'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Continue Button
                _buildContinueButton(),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.storefront_rounded,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required IconData icon,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.mutedClay,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppTheme.primaryColor.withOpacity(0.15)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isSelected ? 20 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 48,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            
            // Selection Indicator
            if (isSelected) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool isEnabled = _selectedRole != null;
    
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.mutedClay,
          disabledForegroundColor: AppTheme.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isEnabled ? 2 : 0,
          shadowColor: AppTheme.primaryColor.withOpacity(0.3),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedRole == null) return;
    
    // TODO: Navigate based on selected role
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continuing as ${_selectedRole == 'buyer' ? 'Buyer' : 'Seller'}'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Custom painter for subtle craft pattern background
class CraftPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Draw decorative circles pattern
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        canvas.drawCircle(
          Offset(
            size.width * (i / 8) + (j % 2 == 0 ? 0 : size.width / 16),
            size.height * (j / 12),
          ),
          12,
          paint,
        );
      }
    }
    
    // Draw decorative lines
    final linePaint = Paint()
      ..color = AppTheme.accentColor.withOpacity(0.04)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 6)),
        Offset(size.width, size.height * (i / 6) + 20),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
