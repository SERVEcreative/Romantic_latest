import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/call_models.dart';
import '../services/call_service.dart';
import 'incoming_call_screen.dart';
import 'outgoing_call_screen.dart';
import '../../../shared/models/user_profile.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  List<Call> _callHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
  }

  Future<void> _loadCallHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await CallService.getCallHistory();
      setState(() {
        _callHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  void _onCallItemTap(Call call) {
    final otherUser = call.isIncoming ? call.caller : call.recipient;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => call.isIncoming
            ? IncomingCallScreen(caller: otherUser)
            : OutgoingCallScreen(recipient: otherUser),
      ),
    );
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
        child: Column(
          children: [
            _buildScreenHeader(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : _buildCallHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.call,
            color: Colors.pink,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Recent Calls',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _loadCallHistory,
            icon: Icon(
              Icons.refresh,
              color: Colors.pink,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
      ),
    );
  }

  Widget _buildCallHistoryList() {
    if (_callHistory.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _callHistory.length,
      itemBuilder: (context, index) {
        return _buildCallItem(_callHistory[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.call_end,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No calls yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your call history will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallItem(Call call) {
    final otherUser = call.isIncoming ? call.caller : call.recipient;
    final isMissed = call.status == CallStatus.missed;
    
    return GestureDetector(
      onTap: () => _onCallItemTap(call),
      child: Container(
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
            _buildProfileAvatar(otherUser),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isMissed ? Colors.red : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        call.isIncoming ? Icons.call_received : Icons.call_made,
                        color: _getCallStatusColor(call.status),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getCallStatusText(call),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _getCallStatusColor(call.status),
                        ),
                      ),
                      if (call.duration != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${_formatDuration(call.duration!)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(call.timestamp),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            _buildCallTypeIcon(call.type),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(UserProfile user) {
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
      child: ClipOval(
        child: user.photoUrl != null
            ? Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  );
                },
              )
            : const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildCallTypeIcon(CallType type) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: type == CallType.video ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        type == CallType.video ? Icons.videocam : Icons.call,
        color: type == CallType.video ? Colors.green : Colors.blue,
        size: 20,
      ),
    );
  }

  Color _getCallStatusColor(CallStatus status) {
    switch (status) {
      case CallStatus.ended:
        return Colors.green;
      case CallStatus.missed:
        return Colors.red;
      case CallStatus.rejected:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getCallStatusText(Call call) {
    switch (call.status) {
      case CallStatus.ended:
        return call.isIncoming ? 'Incoming' : 'Outgoing';
      case CallStatus.missed:
        return 'Missed';
      case CallStatus.rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
