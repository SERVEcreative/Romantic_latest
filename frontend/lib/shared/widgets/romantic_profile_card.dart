import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../../features/coins/services/coin_service.dart';
import '../../features/dashboard/screens/calling_screen.dart';
import '../../features/dashboard/screens/messaging_screen.dart';
import 'dart:io'; // Added for File
import 'dart:ui'; // Added for ImageFilter

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Photo area with overlay info
          _buildPhotoArea(),
          
          // Action buttons
          // _buildActionButtons(), // This line is removed as buttons are now positioned over the photo
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Container(
      height: 480, // Increased height to accommodate action buttons
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Full-size background image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: _buildProfileImage(),
          ),
          
          // Gradient overlay for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280, // Increased to cover action buttons area
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          
          // Translucent profile info overlay
          Positioned(
            bottom: 80, // Moved up to make space for action buttons
            left: 0,
            right: 0,
            child: _buildProfileInfoOverlay(),
          ),
          
          // Action buttons positioned over the photo background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(),
          ),
          
          // Online indicator
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
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and age with translucent background
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
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
                         color: Colors.white,
                         shadows: [
                           Shadow(
                             color: Colors.black.withValues(alpha: 0.5),
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
                        color: Colors.pink.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                                             child: Text(
                         '${widget.profile.age}',
                         style: GoogleFonts.poppins(
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                       ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Location with translucent background
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                                         Text(
                       widget.profile.location,
                       style: GoogleFonts.poppins(
                         fontSize: 14,
                         color: Colors.white,
                         shadows: [
                           Shadow(
                             color: Colors.black.withValues(alpha: 0.5),
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
          const SizedBox(height: 8),
          
          // Bio with translucent background
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                                 child: Text(
                   widget.profile.bio,
                   style: GoogleFonts.poppins(
                     fontSize: 13,
                     color: Colors.white,
                     height: 1.3,
                     shadows: [
                       Shadow(
                         color: Colors.black.withValues(alpha: 0.5),
                         offset: const Offset(0, 1),
                         blurRadius: 2,
                       ),
                     ],
                   ),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // Check if the image path is a local asset
    if (widget.profile.image.startsWith('assets/')) {
      return Image.asset(
        widget.profile.image,
        width: double.infinity,
        height: 480, // Updated height
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
    // Check if it's a local file path
    else if (widget.profile.image.startsWith('/') || widget.profile.image.startsWith('file://')) {
      return Image.file(
        File(widget.profile.image.replaceFirst('file://', '')),
        width: double.infinity,
        height: 480, // Updated height
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
    // Check if it's a network URL
    else if (widget.profile.image.startsWith('http://') || widget.profile.image.startsWith('https://')) {
      return Image.network(
        widget.profile.image,
        width: double.infinity,
        height: 480, // Updated height
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
    // Fallback to emoji or default image
    else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 480, // Updated height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
                         Text(
               widget.profile.name[0].toUpperCase(),
               style: GoogleFonts.poppins(
                 fontSize: 48,
                 fontWeight: FontWeight.bold,
                 color: Colors.grey[600],
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(
         color: widget.profile.online ? Colors.green : Colors.grey.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
                     Text(
             widget.profile.online ? 'Online' : 'Offline',
             style: GoogleFonts.poppins(
               fontSize: 10,
               fontWeight: FontWeight.w500,
               color: Colors.white,
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Call',
              Icons.call,
              Colors.green,
              CoinService.callCost,
              () => _handleCallAction(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'Chat',
              Icons.chat_bubble,
              Colors.blue,
              CoinService.chatCost,
              () => _handleChatAction(),
            ),
          ),
        ],
      ),
    );
  }

     void _handleCallAction() {
     widget.onActionPressed('Call', CoinService.callCost, widget.profile.name);
     // Navigate to calling screen
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => CallingScreen(
           caller: UserProfile(
             id: widget.profile.id,
             name: widget.profile.name,
             fullName: widget.profile.fullName,
             age: widget.profile.age,
             gender: widget.profile.gender,
             bio: widget.profile.bio,
             location: widget.profile.location,
             image: widget.profile.image,
             photoUrl: widget.profile.image.startsWith('http') ? widget.profile.image : null,
             online: widget.profile.online,
             lastSeen: widget.profile.lastSeen,
           ),
           isIncoming: false,
         ),
       ),
     );
   }

     void _handleChatAction() {
     widget.onActionPressed('Chat', CoinService.chatCost, widget.profile.name);
     // Navigate to messaging screen
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => MessagingScreen(
           recipient: UserProfile(
             id: widget.profile.id,
             name: widget.profile.name,
             fullName: widget.profile.fullName,
             age: widget.profile.age,
             gender: widget.profile.gender,
             bio: widget.profile.bio,
             location: widget.profile.location,
             image: widget.profile.image,
             photoUrl: widget.profile.image.startsWith('http') ? widget.profile.image : null,
             online: widget.profile.online,
             lastSeen: widget.profile.lastSeen,
           ),
         ),
       ),
     );
   }

     Widget _buildActionButton(String action, IconData icon, Color color, int cost, VoidCallback onPressed) {
     final hasEnoughCoins = widget.availableCoins >= cost;
    
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: hasEnoughCoins ? color.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: hasEnoughCoins 
            ? Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1)
            : Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
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
                color: hasEnoughCoins ? Colors.white : Colors.white.withValues(alpha: 0.6),
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
                      color: hasEnoughCoins ? Colors.white : Colors.white.withValues(alpha: 0.6),
                      shadows: hasEnoughCoins ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
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
                      color: hasEnoughCoins ? Colors.white.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.4),
                      shadows: hasEnoughCoins ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
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
