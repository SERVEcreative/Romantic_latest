import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/profile_service.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_card_widget.dart';
import '../widgets/profile_menu_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int availableCoins;
  final VoidCallback onCoinOptionsTap;
  final VoidCallback onLogoutTap;

  const ProfileScreen({
    super.key,
    required this.availableCoins,
    required this.onCoinOptionsTap,
    required this.onLogoutTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfileModel? _userProfile;
  bool _isLoading = true;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
    });
    await _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              )
            : RefreshIndicator(
                onRefresh: _refreshProfile,
                color: Colors.pink,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const ProfileHeaderWidget(),
                      const SizedBox(height: 20),
                      if (_userProfile != null)
                        ProfileCardWidget(userProfile: _userProfile!),
                      const SizedBox(height: 20),
                      ProfileMenuWidget(
                        availableCoins: widget.availableCoins,
                        onCoinOptionsTap: widget.onCoinOptionsTap,
                        onLogoutTap: widget.onLogoutTap,
                        onEditProfileTap: _navigateToEditProfile,
                        onSettingsTap: _navigateToSettings,
                        onHelpSupportTap: _navigateToHelpSupport,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    ).then((updatedProfile) {
      if (updatedProfile != null) {
        // Refresh the profile data
        _loadUserProfile();
      }
    });
  }

  void _navigateToSettings() {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings - Coming Soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _navigateToHelpSupport() {
    // TODO: Navigate to help & support screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support - Coming Soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
