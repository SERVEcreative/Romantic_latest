import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../services/coin_service.dart';
import '../services/ad_service.dart';
import '../services/admob_service.dart';
import '../widgets/romantic_profile_card.dart';
import '../widgets/coin_dialogs.dart';
import '../data/sample_data.dart';
import 'settings_screen.dart';
import 'dart:ui'; // Added for ImageFilter

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _availableCoins = CoinService.initialCoins;

  // List of screens for bottom navigation
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    // Initialize and load rewarded ads
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    try {
      await AdMobService.initialize();
      AdMobService.loadRewardedAd();
    } catch (e) {
      print('Failed to initialize ads: $e');
    }
  }

  @override
  void dispose() {
    AdMobService.dispose();
    super.dispose();
  }

  void _initializeScreens() {
    _screens.addAll([
      _buildHomeScreen(),
      _buildCallsScreen(),
      _buildMessagesScreen(),
      _buildProfileScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.pink,
              unselectedItemColor: Colors.grey.withOpacity(0.6),
              selectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                    size: 24,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 1 ? Icons.call_rounded : Icons.call_outlined,
                    size: 24,
                  ),
                  label: 'Calls',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 2 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline,
                    size: 24,
                  ),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 3 ? Icons.person_rounded : Icons.person_outline,
                    size: 24,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Home Screen
  Widget _buildHomeScreen() {
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
            // Header with profile circle and coins
            _buildHeader(),
            
            // Romantic profiles list
            Expanded(
              child: _buildProfilesList(),
            ),
          ],
        ),
      ),
    );
  }

  // Calls Screen
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.call_rounded,
                    color: Colors.pink,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Call History',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            
            // Call history list
            Expanded(
              child: _buildCallHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  // Messages Screen
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.pink,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Messages',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages list
            Expanded(
              child: _buildMessagesList(),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Screen
  Widget _buildProfileScreen() {
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    color: Colors.pink,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'My Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile content
            Expanded(
              child: _buildProfileContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // App title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Romantic Hearts',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Find your perfect match',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Coins display
          GestureDetector(
            onTap: _showCoinOptions,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber.withOpacity(0.9),
                    Colors.orange.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_availableCoins',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildProfilesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: SampleData.romanticProfiles.length,
      itemBuilder: (context, index) {
        final profile = SampleData.romanticProfiles[index];
        return RomanticProfileCard(
          profile: profile,
          availableCoins: _availableCoins,
          onActionPressed: _handleActionPressed,
        );
      },
    );
  }

  Widget _buildCallHistoryList() {
    // Sample call history data
    final List<Map<String, dynamic>> callHistory = [
      {'name': 'Sarah', 'time': '2 min ago', 'duration': '5:23', 'type': 'incoming'},
      {'name': 'Emma', 'time': '1 hour ago', 'duration': '12:45', 'type': 'outgoing'},
      {'name': 'Sophia', 'time': '3 hours ago', 'duration': '8:12', 'type': 'missed'},
      {'name': 'Isabella', 'time': 'Yesterday', 'duration': '15:30', 'type': 'incoming'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: callHistory.length,
      itemBuilder: (context, index) {
        final call = callHistory[index];
        return Container(
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
                child: Center(
                  child: Icon(
                    call['type'] == 'incoming' ? Icons.call_received : 
                    call['type'] == 'outgoing' ? Icons.call_made : Icons.call_missed,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      call['name'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${call['duration']} • ${call['time']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.call,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    // Sample messages data
    final List<Map<String, dynamic>> messages = [
      {'name': 'Sarah', 'lastMessage': 'Hey! How are you doing? 💕', 'time': '2 min ago', 'unread': 2},
      {'name': 'Emma', 'lastMessage': 'That sounds amazing! 🌟', 'time': '1 hour ago', 'unread': 0},
      {'name': 'Sophia', 'lastMessage': 'Let\'s meet up soon! 😊', 'time': '3 hours ago', 'unread': 1},
      {'name': 'Isabella', 'lastMessage': 'Thanks for the lovely chat 💖', 'time': 'Yesterday', 'unread': 0},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Container(
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
                child: Center(
                  child: Text(
                    (message['name'] as String)[0],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          message['time'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['lastMessage'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if ((message['unread'] as int) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${message['unread']}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Name',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Age • Location',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Menu items
          _buildProfileMenuItem(
            icon: Icons.edit,
            title: 'Edit Profile',
            subtitle: 'Update your information',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          
          _buildProfileMenuItem(
            icon: Icons.monetization_on,
            title: 'My Coins',
            subtitle: '$_availableCoins coins available',
            onTap: _showCoinOptions,
          ),
          
          _buildProfileMenuItem(
            icon: Icons.play_circle,
            title: 'Watch Ads',
            subtitle: 'Earn coins by watching videos',
            onTap: _watchAdForCoins,
          ),
          
          _buildProfileMenuItem(
            icon: Icons.favorite,
            title: 'My Matches',
            subtitle: 'View your connections',
            onTap: () {},
          ),
          
          _buildProfileMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences',
            onTap: () {},
          ),
          
          _buildProfileMenuItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {},
          ),
          
          _buildProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.pink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.pink,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _handleActionPressed(String action, int cost, String profileName) {
    if (_availableCoins >= cost) {
      setState(() {
        _availableCoins -= cost;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$action with $profileName initiated! 💕'),
          backgroundColor: Colors.pink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      CoinDialogs.showInsufficientCoinsDialog(context, cost, _availableCoins, () {
        _showCoinOptions();
      });
    }
  }

  void _showCoinOptions() {
    CoinDialogs.showEarnCoinsDialog(
      context,
      () => _watchAdForCoins(), // Watch ads callback
      () => CoinDialogs.showBuyCoinsDialog(context, (coins) {
        setState(() {
          _availableCoins += coins;
        });
      }), // Buy coins callback
    );
  }

  void _watchAdForCoins() {
    // Try AdMob first, fallback to demo if needed
    AdMobService.showRewardedAd(context, (coins) {
      setState(() {
        _availableCoins += coins;
      });
    });
    
    // Temporary fallback - just add coins directly
    // setState(() {
    //   _availableCoins += 10;
    // });
    
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Demo mode: +10 coins added! 🎉'),
    //     backgroundColor: Colors.green,
    //     behavior: SnackBarBehavior.floating,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
