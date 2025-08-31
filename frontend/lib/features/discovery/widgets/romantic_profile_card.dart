import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/user_profile.dart';
import '../../coins/services/coin_service.dart';
import '../../calls/screens/outgoing_call_screen.dart';
import '../../calls/models/call_models.dart';
import '../../messaging/screens/chat_screen.dart';
import '../../messaging/models/message_models.dart';
import '../../../core/constants/app_colors.dart';
import 'dart:io';
import 'dart:ui';

class RomanticProfileCard extends StatefulWidget {
  final UserProfile profile;
  final int availableCoins;
  final Function(String, int, String) onActionPressed;

  const RomanticProfileCard({
    super.key,
    required this.profile,
    required this.availableCoins,
    required this.onActionPressed,
  });

  @override
  State<RomanticProfileCard> createState() => _RomanticProfileCardState();
}

class _RomanticProfileCardState extends State<RomanticProfileCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildPhotoArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Container(
      height: 480,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: _buildProfileImage(),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.textPrimary.withValues(alpha: 0.2),
                    AppColors.textPrimary.withValues(alpha: 0.6),
                    AppColors.textPrimary.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: _buildProfileInfoOverlay(),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(),
          ),
          
          Positioned(
            top: 16,
            right: 16,
            child: _buildOnlineIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoOverlay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.profile.name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.surface,
                        shadows: [
                          Shadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.profile.age}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.profile.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.surface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.profile.location,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.surface,
                          shadows: [
                            Shadow(
                              color: AppColors.textPrimary.withValues(alpha: 0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (widget.profile.bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profile.bio,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.surface,
                          height: 1.3,
                          shadows: [
                            Shadow(
                              color: AppColors.textPrimary.withValues(alpha: 0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.profile.isSuperLover && widget.profile.superLoverRating != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.profile.superLoverRating!.toStringAsFixed(1)} (${widget.profile.superLoverCallCount ?? 0} calls)',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // Check if we have a valid profile image
    final hasValidImage = widget.profile.image.isNotEmpty && 
                         widget.profile.image != 'null' &&
                         widget.profile.photoUrl != null &&
                         widget.profile.photoUrl!.isNotEmpty &&
                         widget.profile.photoUrl != 'null';
    
    if (!hasValidImage) {
      return _buildDefaultAvatar();
    }
    
    if (widget.profile.image.startsWith('assets/')) {
      return Image.asset(
        widget.profile.image,
        width: double.infinity,
        height: 480,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else if (widget.profile.image.startsWith('/') || widget.profile.image.startsWith('file://')) {
      return Image.file(
        File(widget.profile.image.replaceFirst('file://', '')),
        width: double.infinity,
        height: 480,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else if (widget.profile.image.startsWith('http://') || widget.profile.image.startsWith('https://')) {
      return Image.network(
        widget.profile.image,
        width: double.infinity,
        height: 480,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    // Generate a unique color based on user's name
    final name = widget.profile.name.isNotEmpty ? widget.profile.name : 'User';
    final colors = [
      AppColors.primary, // Pink
      AppColors.secondary, // Purple
      AppColors.info, // Blue
      AppColors.success, // Green
      AppColors.warning, // Orange
      AppColors.accent, // Orange
      AppColors.primaryDark, // Dark Pink
      AppColors.secondaryDark, // Dark Purple
      AppColors.accentDark, // Dark Orange
      AppColors.primaryLight, // Light Pink
      AppColors.secondaryLight, // Light Purple
      AppColors.accentLight, // Light Orange
      AppColors.textSecondary, // Grey
      AppColors.textLight, // Light Grey
    ];
    
    final colorIndex = name.hashCode.abs() % colors.length;
    final backgroundColor = colors[colorIndex];
    
    return Container(
      width: double.infinity,
      height: 480,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withValues(alpha: 0.8),
            backgroundColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.surface,
            letterSpacing: 3.0,
            shadows: [
              Shadow(
                color: AppColors.textPrimary.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.profile.online ? AppColors.success : AppColors.textSecondary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            widget.profile.online ? 'Online' : 'Offline',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Call',
              Icons.call,
              AppColors.success,
              widget.profile.callCost.toInt(),
              () => _handleCallAction(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'Chat',
              Icons.chat_bubble,
              AppColors.info,
              widget.profile.chatCost.toInt(),
              () => _handleChatAction(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCallAction() {
    widget.onActionPressed('Call', widget.profile.callCost.toInt(), widget.profile.name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutgoingCallScreen(
          recipient: widget.profile,
        ),
      ),
    );
  }

  void _handleChatAction() {
    widget.onActionPressed('Chat', widget.profile.chatCost.toInt(), widget.profile.name);
    final conversation = Conversation(
      id: 'conv_${widget.profile.id}',
      participant: widget.profile,
      lastMessage: null,
      lastActivity: DateTime.now(),
      unreadCount: 0,
      isOnline: widget.profile.online,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversation: conversation),
      ),
    );
  }

  Widget _buildActionButton(String action, IconData icon, Color color, int cost, VoidCallback onPressed) {
    final hasEnoughCoins = widget.availableCoins >= cost;
    
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: hasEnoughCoins ? color.withValues(alpha: 0.9) : AppColors.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: hasEnoughCoins 
            ? Border.all(color: AppColors.surface.withValues(alpha: 0.3), width: 1)
            : Border.all(color: AppColors.surface.withValues(alpha: 0.2), width: 1),
        boxShadow: hasEnoughCoins ? [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasEnoughCoins ? onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: hasEnoughCoins ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
                size: 18,
              ),
              const SizedBox(width: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasEnoughCoins ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
                      shadows: hasEnoughCoins ? [
                        Shadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ] : null,
                    ),
                  ),
                  Text(
                    '$cost coins',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: hasEnoughCoins ? AppColors.surface.withValues(alpha: 0.9) : AppColors.surface.withValues(alpha: 0.4),
                      shadows: hasEnoughCoins ? [
                        Shadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 1,
                        ),
                      ] : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
