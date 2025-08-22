import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/models/sample_data.dart';
import '../../../../shared/widgets/romantic_profile_card.dart';

class HomeWidget extends StatelessWidget {
  final int availableCoins;
  final Function(String, int, String) onActionPressed;
  final VoidCallback onCoinOptionsTap;

  const HomeWidget({
    super.key,
    required this.availableCoins,
    required this.onActionPressed,
    required this.onCoinOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildHeader(),
            Expanded(
              child: _buildProfilesList(),
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
          _buildCoinDisplay(),
        ],
      ),
    );
  }

  Widget _buildCoinDisplay() {
    return GestureDetector(
      onTap: onCoinOptionsTap,
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
              '$availableCoins',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
          availableCoins: availableCoins,
          onActionPressed: onActionPressed,
        );
      },
    );
  }
}
