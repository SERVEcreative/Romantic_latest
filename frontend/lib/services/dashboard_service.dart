import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/coin_service.dart';
import '../services/admob_service.dart';
import '../widgets/coin_dialogs.dart';

class DashboardService {
  static void handleActionPressed(
    BuildContext context,
    String action,
    int cost,
    String profileName,
    int availableCoins,
    Function(int) onCoinsChanged,
  ) {
    if (availableCoins >= cost) {
      onCoinsChanged(availableCoins - cost);
      
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
      CoinDialogs.showInsufficientCoinsDialog(
        context,
        cost,
        availableCoins,
        () => showCoinOptions(context, onCoinsChanged),
      );
    }
  }

  static void showCoinOptions(BuildContext context, Function(int) onCoinsChanged) {
    CoinDialogs.showEarnCoinsDialog(
      context,
      () => watchAdForCoins(context, onCoinsChanged),
      () => CoinDialogs.showBuyCoinsDialog(context, (coins) {
        onCoinsChanged(coins);
      }),
    );
  }

  static void watchAdForCoins(BuildContext context, Function(int) onCoinsChanged) {
    AdMobService.showRewardedAd(context, (coins) {
      onCoinsChanged(coins);
    });
  }

  static void showLogoutDialog(BuildContext context) {
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
