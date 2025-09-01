import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];
  final Map<String, bool> _typingUsers = {};
  bool _isConnected = false;
  IO.Socket? _socket;

  List<Message> get messages => _messages;
  Map<String, bool> get typingUsers => _typingUsers;
  bool get isConnected => _isConnected;

  // Initialize chat for a specific conversation
  Future<void> initializeChat(String otherUserId, String authToken, String currentUserId) async {
    try {
      await ChatService.initializeSocket(authToken, currentUserId);
      _socket = ChatService.socket;
      
      await loadMessages(otherUserId);
      _setupSocketListeners(otherUserId);
      
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      print('❌ Error initializing chat: $e');
    }
  }

  void _setupSocketListeners(String otherUserId) {
    if (_socket == null) return;

    // Remove existing listeners to prevent duplicates
    _socket!.off('new_message');
    _socket!.off('user_typing');
    _socket!.off('messages_read_by');

    _socket!.on('new_message', (data) async {
      final messageData = data['message'];
      final currentUserId = await ChatService.getCurrentUserId();
      
      print('🔍 [DEBUG] Received message - Sender: ${messageData['sender_id']}, Current User: $currentUserId, Other User: $otherUserId');
      print('🔍 [DEBUG] Message text: ${messageData['message_text']}');
      print('🔍 [DEBUG] Message ID: ${messageData['id']}');
      print('🔍 [DEBUG] Current messages count: ${_messages.length}');
      
      // Only add messages from the other user (not our own messages)
      // Our own messages are handled by optimistic UI updates
      if (messageData['sender_id'] == otherUserId) {
        // Check if we already have this message to prevent duplicates
        final messageId = messageData['id'];
        final messageText = messageData['message_text'];
        final createdAt = DateTime.parse(messageData['created_at']);
        
        // Check for duplicates by ID, text, and timestamp
        print('🔍 [DEBUG] Checking for duplicates...');
        print('🔍 [DEBUG] Looking for message ID: $messageId');
        print('🔍 [DEBUG] Looking for message text: $messageText');
        
        final existingMessage = _messages.any((msg) => 
          msg.id == messageId || 
          (msg.messageText == messageText && 
           msg.senderId == otherUserId && 
           msg.createdAt.difference(createdAt).abs().inSeconds < 5)
        );
        
        print('🔍 [DEBUG] Existing message found: $existingMessage');
        print('🔍 [DEBUG] Current messages in list:');
        for (int i = 0; i < _messages.length; i++) {
          print('  [$i] ID: ${_messages[i].id}, Text: ${_messages[i].messageText}, Sender: ${_messages[i].senderId}');
        }
        
        if (!existingMessage) {
          final message = Message.fromJson(messageData);
          _messages.add(message);
          notifyListeners();
          print('✅ [DEBUG] Added new message from other user');
        } else {
          print('⚠️ [DEBUG] Message already exists, ignoring duplicate');
        }
      } else {
        print('ℹ️ [DEBUG] Ignoring message from current user');
      }
    });

    _socket!.on('user_typing', (data) {
      if (data['user_id'] == otherUserId) {
        _typingUsers[otherUserId] = data['is_typing'];
        notifyListeners();
      }
    });

    _socket!.on('messages_read_by', (data) {
      if (data['user_id'] == otherUserId) {
        for (int i = 0; i < _messages.length; i++) {
          if (_messages[i].receiverId == otherUserId) {
            _messages[i] = _messages[i].copyWith(
              isRead: true,
              readAt: DateTime.parse(data['read_at']),
            );
          }
        }
        notifyListeners();
      }
    });
  }

  // Load messages from API
  Future<void> loadMessages(String otherUserId) async {
    try {
      final messagesData = await ChatService.getMessages(otherUserId);
      _messages.clear();
      _messages.addAll(messagesData.map((data) => Message.fromJson(data)));
      notifyListeners();
    } catch (e) {
      print('❌ Error loading messages: $e');
    }
  }

  // Send message
  Future<void> sendMessage(String receiverId, String messageText) async {
    try {
      print('📤 [DEBUG] Sending message to: $receiverId');
      print('📤 [DEBUG] Message text: $messageText');
      
      // Add message optimistically to UI (for immediate feedback)
      final currentUserId = await ChatService.getCurrentUserId();
      if (currentUserId != null) {
        final tempMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
          senderId: currentUserId,
          receiverId: receiverId,
          messageText: messageText,
          messageType: 'text',
          isRead: false,
          createdAt: DateTime.now(),
        );
        _messages.add(tempMessage);
        notifyListeners();
        print('✅ [DEBUG] Added optimistic message to UI');
      }
      
      // Send via Socket.io for real-time delivery
      ChatService.sendMessageSocket(receiverId, messageText);
      print('📤 [DEBUG] Sent message via Socket.io');
      
    } catch (e) {
      print('❌ Error sending message: $e');
    }
  }

  // Send typing indicator
  void startTyping(String receiverId) {
    ChatService.sendTypingStart(receiverId);
  }

  void stopTyping(String receiverId) {
    ChatService.sendTypingStop(receiverId);
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String otherUserId) async {
    try {
      ChatService.markMessagesAsReadSocket(otherUserId);
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  // Clear chat data
  void clearChat() {
    _messages.clear();
    _typingUsers.clear();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    ChatService.disconnect();
    super.dispose();
  }
}