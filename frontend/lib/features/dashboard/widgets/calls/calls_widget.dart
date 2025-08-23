import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCallHistoryList(),
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
          const Icon(
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
    );
  }

  Widget _buildCallHistoryList() {
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
        return _buildCallItem(call);
      },
    );
  }

  Widget _buildCallItem(Map<String, dynamic> call) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCallIcon(call['type']),
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
          const Icon(
            Icons.call,
            color: Colors.green,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCallIcon(String type) {
    IconData iconData;
    switch (type) {
      case 'incoming':
        iconData = Icons.call_received;
        break;
      case 'outgoing':
        iconData = Icons.call_made;
        break;
      case 'missed':
        iconData = Icons.call_missed;
        break;
      default:
        iconData = Icons.call;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: 0.8),
            Colors.purple.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
