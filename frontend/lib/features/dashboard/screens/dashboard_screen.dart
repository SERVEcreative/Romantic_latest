import 'package:flutter/material.dart';
import '../../coins/services/coin_service.dart';
import '../../coins/services/admob_service.dart';
import '../services/dashboard_service.dart';
import '../widgets/home/home_widget.dart';
import 'calling_screen.dart';
import 'messaging_screen.dart';
import '../widgets/profile/profile_widget.dart';
import '../widgets/navigation/bottom_navigation_widget.dart';
import '../../../shared/models/user_profile.dart';

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
        return HomeWidget(
          availableCoins: _availableCoins,
          onActionPressed: _handleActionPressed,
          onCoinOptionsTap: _showCoinOptions,
        );
      case 1:
        return _buildCallsScreen();
      case 2:
        return _buildMessagesScreen();
      case 3:
        return ProfileWidget(
          availableCoins: _availableCoins,
          onCoinOptionsTap: _showCoinOptions,
          onWatchAdsTap: _watchAdForCoins,
          onLogoutTap: _showLogoutDialog,
        );
      default:
        return HomeWidget(
          availableCoins: _availableCoins,
          onActionPressed: _handleActionPressed,
          onCoinOptionsTap: _showCoinOptions,
        );
    }
  }

  Widget _buildCallsScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildScreenHeader('Recent Calls', Icons.call),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildCallItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildScreenHeader('Messages', Icons.message),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildMessageItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.pink,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallItem(int index) {
    final names = ['Sarah Johnson', 'Emma Wilson', 'Olivia Davis', 'Sophia Brown', 'Isabella Miller'];
    final times = ['2 min ago', '5 min ago', '1 hour ago', '2 hours ago', '1 day ago'];
    final isIncoming = [true, false, true, false, true];
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingScreen(
                             caller: UserProfile(
                 id: 'user_$index',
                 name: names[index],
                 fullName: names[index],
                 age: 25 + index,
                 gender: 'female',
                 bio: 'Love traveling and coffee ☕',
                 location: 'New York',
                 image: '',
                 photoUrl: null,
                 online: true,
                 lastSeen: '2 min ago',
               ),
              isIncoming: isIncoming[index],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.withOpacity(0.8),
                    Colors.purple.withOpacity(0.6),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    times[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isIncoming[index] ? Icons.call_received : Icons.call_made,
              color: isIncoming[index] ? Colors.green : Colors.red,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(int index) {
    final names = ['Sarah Johnson', 'Emma Wilson', 'Olivia Davis', 'Sophia Brown', 'Isabella Miller'];
    final messages = ['Hey! How are you?', 'That sounds great!', 'See you soon!', 'Thanks!', 'Love you! 💕'];
    final times = ['2 min ago', '5 min ago', '1 hour ago', '2 hours ago', '1 day ago'];
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingScreen(
                             recipient: UserProfile(
                 id: 'user_$index',
                 name: names[index],
                 fullName: names[index],
                 age: 25 + index,
                 gender: 'female',
                 bio: 'Love traveling and coffee ☕',
                 location: 'New York',
                 image: '',
                 photoUrl: null,
                 online: true,
                 lastSeen: '2 min ago',
               ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink.withOpacity(0.8),
                    Colors.purple.withOpacity(0.6),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    messages[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  times[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
