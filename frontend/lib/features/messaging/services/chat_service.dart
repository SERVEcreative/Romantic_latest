import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../core/services/api_service.dart';

class ChatService {
  static IO.Socket? _socket;
  static String? _authToken;
  static String? _currentUserId;

  // Initialize Socket.io connection
  static Future<void> initializeSocket(String token, String userId) async {
    _authToken = token;
    _currentUserId = userId;

    _socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.auth = {'token': token};
    _socket!.connect();

    _setupEventListeners();
  }

  // Setup Socket.io event listeners
  static void _setupEventListeners() {
    _socket!.on('connect', (_) {
      print('✅ Connected to chat server');
    });

    _socket!.on('disconnect', (_) {
      print('❌ Disconnected from chat server');
    });

    _socket!.on('new_message', (data) {
      print('📨 New message received: $data');
    });

    _socket!.on('message_sent', (data) {
      print('✅ Message sent successfully: $data');
    });

    _socket!.on('message_error', (data) {
      print('❌ Message error: $data');
    });

    _socket!.on('user_typing', (data) {
      print('⌨️ User typing: $data');
    });

    _socket!.on('messages_read', (data) {
      print('👁️ Messages read: $data');
    });

    _socket!.on('user_status_changed', (data) {
      print('📱 User status changed: $data');
    });
  }

  // Get current user ID (for ChatProvider)
  static Future<String?> getCurrentUserId() async {
    return _currentUserId;
  }

  // Check or create conversation between two users
  static Future<Map<String, dynamic>?> checkOrCreateConversation(String otherUserId) async {
    try {
      final response = await ApiService.get('/chat/conversation/$otherUserId');
      
      if (response is Map<String, dynamic> && response['success'] == true) {
        return response['conversation'];
      }
      return null;
    } catch (e) {
      print('❌ Error checking/creating conversation: $e');
      return null;
    }
  }

  // Get messages between two users
  static Future<List<Map<String, dynamic>>> getMessages(String otherUserId, {int page = 1, int limit = 50}) async {
    try {
      final response = await ApiService.get('/chat/messages/$otherUserId?page=$page&limit=$limit');
      
      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['messages']);
      }
      return [];
    } catch (e) {
      print('❌ Error getting messages: $e');
      return [];
    }
  }



  // Send message via Socket.io (for real-time)
  static void sendMessageSocket(String receiverId, String messageText, {String messageType = 'text', String? mediaUrl}) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('send_message', {
        'receiver_id': receiverId,
        'message_text': messageText,
        'message_type': messageType,
        'media_url': mediaUrl,
      });
    }
  }

  // Send typing indicator
  static void sendTypingStart(String receiverId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('typing_start', {'receiver_id': receiverId});
    }
  }

  static void sendTypingStop(String receiverId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('typing_stop', {'receiver_id': receiverId});
    }
  }

  // Mark messages as read via Socket.io
  static void markMessagesAsReadSocket(String otherUserId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('mark_read', {'other_user_id': otherUserId});
    }
  }

  // Get Socket instance (for ChatProvider)
  static IO.Socket? get socket => _socket;

  // Disconnect socket
  static void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
  }
}