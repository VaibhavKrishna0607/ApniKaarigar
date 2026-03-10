import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_data_provider.dart';
import '../services/marketplace_service.dart';
import 'auth_screen.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _authService = AuthService();
  final _userDataProvider = UserDataProvider();
  bool _hasAttemptedLoad = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading state - only show while checking auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking authentication...'),
                ],
              ),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // Load user data in background (don't block UI)
          if (!_hasAttemptedLoad) {
            _hasAttemptedLoad = true;
            // Load data without blocking
            Future.microtask(() => _loadUserData());
          }

          // Use ValueKey(uid) so Flutter recreates MainNavigation for each user
          return KeyedSubtree(
            key: ValueKey(snapshot.data!.uid),
            child: widget.child,
          );
        }

        // User is not logged in - clear data and show auth screen
        _hasAttemptedLoad = false;
        _userDataProvider.clearData();
        MarketplaceService().clearData();
        return const AuthScreen();
      },
    );
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    try {
      await _userDataProvider.loadUserData();
      debugPrint('User data loaded successfully');
    } catch (e) {
      debugPrint('Error loading user data in AuthWrapper: $e');
    }
  }
}
