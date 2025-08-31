import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../core/utils/logger.dart';
import '../../auth/screens/login_screen.dart';
import '../screens/dashboard_screen.dart';

class NavigationService {
  /// Navigate to login screen and clear all routes
  static void navigateToLogin() {
    try {
      final navigator = RomanticLoginApp.navigatorKey.currentState;
      if (navigator != null) {
        // Clear all routes and navigate to login
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all routes
        );
        Logger.success('Navigation to login screen completed');
      } else {
        Logger.error('Navigator is null, cannot navigate to login');
      }
    } catch (e) {
      Logger.error('Failed to navigate to login screen', e);
    }
  }

  /// Navigate to dashboard screen and clear all routes
  static void navigateToDashboard() {
    try {
      final navigator = RomanticLoginApp.navigatorKey.currentState;
      if (navigator != null) {
        // Clear all routes and navigate to dashboard
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false, // Remove all routes
        );
        Logger.success('Navigation to dashboard completed');
      } else {
        Logger.error('Navigator is null, cannot navigate to dashboard');
      }
    } catch (e) {
      Logger.error('Failed to navigate to dashboard', e);
    }
  }

  /// Pop current route
  static void pop() {
    try {
      final navigator = RomanticLoginApp.navigatorKey.currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        Logger.info('Popped current route');
      } else {
        Logger.warning('Cannot pop route - navigator is null or cannot pop');
      }
    } catch (e) {
      Logger.error('Failed to pop route', e);
    }
  }

  /// Check if navigator is available
  static bool isNavigatorAvailable() {
    return RomanticLoginApp.navigatorKey.currentState != null;
  }
}
