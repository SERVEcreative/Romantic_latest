import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class DashboardBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const DashboardBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
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
              currentIndex: selectedIndex,
              onTap: onItemTapped,
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
              items: _buildNavigationItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
          size: 24,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          selectedIndex == 1 ? Icons.call_rounded : Icons.call_outlined,
          size: 24,
        ),
        label: 'Calls',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          selectedIndex == 2 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline,
          size: 24,
        ),
        label: 'Messages',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          selectedIndex == 3 ? Icons.person_rounded : Icons.person_outline,
          size: 24,
        ),
        label: 'Profile',
      ),
    ];
  }
}
