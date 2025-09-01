import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/chat_provider.dart';
import '../../../core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/token_service.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String conversationId;

  const ChatScreen({
    Key? key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.conversationId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatProvider? _chatProvider;
  String? _authToken;
  String? _currentUserId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      print('🚀 [CHAT_SCREEN] Starting chat initialization...');
      
      // Use TokenService to get the data directly
      _authToken = await TokenService.getToken();
      _currentUserId = await TokenService.getUserId();
      
      print('🔍 [CHAT_SCREEN] Auth Token: ${_authToken != null ? 'Found (${_authToken!.substring(0, 20)}...)' : 'Not found'}');
      print('🔍 [CHAT_SCREEN] User ID: ${_currentUserId != null ? 'Found ($_currentUserId)' : 'Not found'}');

      if (_authToken == null || _currentUserId == null) {
        throw Exception('Authentication data not found');
      }

      print('🚀 [CHAT_SCREEN] Getting ChatProvider...');
      _chatProvider = Provider.of<ChatProvider>(context, listen: false);
      print('✅ [CHAT_SCREEN] ChatProvider obtained: $_chatProvider');
      
      print('🚀 [CHAT_SCREEN] Initializing chat...');
      await _chatProvider!.initializeChat(widget.otherUserId, _authToken!, _currentUserId!);
      print('✅ [CHAT_SCREEN] Chat initialized');
      
      print('🚀 [CHAT_SCREEN] Marking messages as read...');
      await _chatProvider!.markMessagesAsRead(widget.otherUserId);
      print('✅ [CHAT_SCREEN] Messages marked as read');

      _isInitialized = true;
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('❌ [CHAT_SCREEN] Error initializing chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize chat'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _chatProvider == null) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    print('📤 [CHAT_SCREEN] Sending message: $messageText');
    await _chatProvider!.sendMessage(widget.otherUserId, messageText);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.surface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Loading...',
            style: GoogleFonts.poppins(
              color: AppColors.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Initializing chat...',
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.surface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.secondary,
              backgroundImage: widget.otherUserAvatar != null && widget.otherUserAvatar!.isNotEmpty
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              child: widget.otherUserAvatar == null || widget.otherUserAvatar!.isEmpty
                  ? Text(
                      widget.otherUserName[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: AppColors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.surface,
                    ),
                  ),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      final isTyping = chatProvider.typingUsers[widget.otherUserId] == true;
                      return Text(
                        isTyping ? 'Typing...' : 'Online',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.surface.withValues(alpha: 0.8),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: AppColors.surface),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Call feature coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: AppColors.surface),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Video call feature coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start the conversation with ${widget.otherUserName}!',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    final isMe = message.senderId == _currentUserId;
                    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.messageText,
                              style: GoogleFonts.poppins(
                                color: isMe ? AppColors.surface : AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(message.createdAt),
                                  style: GoogleFonts.poppins(
                                    color: isMe 
                                        ? AppColors.surface.withValues(alpha: 0.8)
                                        : AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                if (isMe) ...[
                                  SizedBox(width: 4),
                                  Icon(
                                    message.isRead ? Icons.done_all : Icons.done,
                                    size: 16,
                                    color: message.isRead 
                                        ? AppColors.success
                                        : AppColors.surface.withValues(alpha: 0.8),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.textSecondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    onChanged: (text) {
                      if (_chatProvider != null) {
                        if (text.isNotEmpty) {
                          _chatProvider!.startTyping(widget.otherUserId);
                        } else {
                          _chatProvider!.stopTyping(widget.otherUserId);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.surface),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}