import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/user_profile.dart';
import '../models/call_models.dart';
import '../services/call_service.dart';

class OutgoingCallScreen extends StatefulWidget {
  final UserProfile recipient;

  const OutgoingCallScreen({
    super.key,
    required this.recipient,
  });

  @override
  State<OutgoingCallScreen> createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends State<OutgoingCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoEnabled = false;
  Duration _callDuration = Duration.zero;
  late Timer _timer;
  bool _isCallConnected = false;
  bool _isCallEnded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCallTimer();
    _initiateCall();
  }

  void _initializeAnimations() {
    // Pulse animation for the main profile image
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Ripple animation for background effects
    _rippleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _pulseController.repeat(reverse: true);
    _rippleController.repeat();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCallConnected) {
        setState(() {
          _callDuration += const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _initiateCall() async {
    try {
      await CallService.makeCall(widget.recipient, CallType.audio);
      // Simulate call connection after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isCallConnected = true;
          });
        }
      });
    } catch (e) {
      // Handle call initiation error
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withValues(alpha: 0.8),
              Colors.pink.withValues(alpha: 0.6),
              Colors.deepPurple.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildCallContent(),
              ),
              _buildCallControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
          const Spacer(),
          if (_isCallConnected)
            Text(
              _formatDuration(_callDuration),
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the header
        ],
      ),
    );
  }

  Widget _buildCallContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProfileSection(),
        const SizedBox(height: 40),
        _buildCallStatus(),
        const SizedBox(height: 60),
        _buildCallInfo(),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple effect
        AnimatedBuilder(
          animation: _rippleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_rippleAnimation.value * 0.3),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            );
          },
        ),
        // Main profile image with pulse
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 150,
                height: 150,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.recipient.photoUrl != null
                      ? Image.network(
                          widget.recipient.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
            );
          },
        ),
        // Video indicator
        if (_isVideoEnabled)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.videocam,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: 0.8),
            Colors.purple.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildCallStatus() {
    return Column(
      children: [
        Text(
          widget.recipient.fullName,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isCallConnected ? 'Connected' : 'Calling...',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        if (!_isCallConnected) ...[
          const SizedBox(height: 8),
          Text(
            'Please wait while we connect you...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCallInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                icon: Icons.location_on,
                label: widget.recipient.location,
              ),
              _buildInfoItem(
                icon: Icons.cake,
                label: '${widget.recipient.age} years',
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (widget.recipient.bio.isNotEmpty)
            Text(
              widget.recipient.bio,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.7),
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          // Secondary controls (only show when call is connected)
          if (_isCallConnected) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  label: _isMuted ? 'Unmute' : 'Mute',
                  color: _isMuted ? Colors.red : Colors.white,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                _buildControlButton(
                  icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                  label: _isSpeakerOn ? 'Speaker' : 'Speaker',
                  color: _isSpeakerOn ? Colors.blue : Colors.white,
                  onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                ),
                _buildControlButton(
                  icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                  label: _isVideoEnabled ? 'Video' : 'Video',
                  color: _isVideoEnabled ? Colors.green : Colors.white,
                  onTap: () => setState(() => _isVideoEnabled = !_isVideoEnabled),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
          // Main call controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMainControlButton(
                icon: Icons.call_end,
                color: Colors.red,
                onTap: _endCall,
                isEndCall: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isEndCall ? 80 : 60,
        height: isEndCall ? 80 : 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: isEndCall ? 32 : 28,
        ),
      ),
    );
  }

  Future<void> _endCall() async {
    try {
      await CallService.endCall('outgoing_call_${widget.recipient.id}');
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      Navigator.pop(context);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
