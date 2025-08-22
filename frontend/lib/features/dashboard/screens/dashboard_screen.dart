import 'package:flutter/material.dart';
import '../../coins/services/coin_service.dart';
import '../../coins/services/admob_service.dart';
import '../services/dashboard_service.dart';
import '../widgets/dashboard/home_screen.dart';
import '../widgets/dashboard/calls_screen.dart';
import '../widgets/dashboard/messages_screen.dart';
import '../widgets/dashboard/profile_screen.dart';
import '../widgets/dashboard/bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _availableCoins = CoinService.initialCoins;

  @override
  void initState() {
    super.initState();
    _initializeAds();
  }

  @override
  void dispose() {
    AdMobService.dispose();
    super.dispose();
  }

  Future<void> _initializeAds() async {
    try {
      await AdMobService.initialize();
      AdMobService.loadRewardedAd();
    } catch (e) {
      print('Failed to initialize ads: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCoinsChanged(int newCoins) {
    setState(() {
      _availableCoins = newCoins;
    });
  }

  void _handleActionPressed(String action, int cost, String profileName) {
    DashboardService.handleActionPressed(
      context,
      action,
      cost,
      profileName,
      _availableCoins,
      _onCoinsChanged,
    );
  }

  void _showCoinOptions() {
    DashboardService.showCoinOptions(context, _onCoinsChanged);
  }

  void _watchAdForCoins() {
    DashboardService.watchAdForCoins(context, _onCoinsChanged);
  }

  void _showLogoutDialog() {
    DashboardService.showLogoutDialog(context);
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(
          availableCoins: _availableCoins,
          onActionPressed: _handleActionPressed,
          onCoinOptionsTap: _showCoinOptions,
        );
      case 1:
        return const CallsScreen();
      case 2:
        return const MessagesScreen();
      case 3:
        return ProfileScreen(
          availableCoins: _availableCoins,
          onCoinOptionsTap: _showCoinOptions,
          onWatchAdsTap: _watchAdForCoins,
          onLogoutTap: _showLogoutDialog,
        );
      default:
        return HomeScreen(
          availableCoins: _availableCoins,
          onActionPressed: _handleActionPressed,
          onCoinOptionsTap: _showCoinOptions,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: DashboardBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
