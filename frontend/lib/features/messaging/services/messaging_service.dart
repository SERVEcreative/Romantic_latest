import '../../../shared/models/user_profile.dart';
import '../models/message_models.dart';
import '../../../core/utils/logger.dart';

class MessagingService {
  static final List<Conversation> _conversations = [];
  static final Map<String, List<Message>> _messages = {};
  
  // Mock data for demonstration
  static List<Conversation> getMockConversations() {
    final names = ['Sarah Johnson', 'Emma Wilson', 'Olivia Davis', 'Sophia Brown', 'Isabella Miller'];
    final messages = ['Hey! How are you?', 'That sounds great!', 'See you soon!', 'Thanks!', 'Love you! 💕'];
    final times = [
      DateTime.now().subtract(const Duration(minutes: 2)),
      DateTime.now().subtract(const Duration(minutes: 5)),
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().subtract(const Duration(hours: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
    ];

    return List.generate(5, (index) {
      final user = UserProfile(
        id: 'user_$index',
        name: names[index],
        fullName: names[index],
        age: 25 + index,
        gender: 'female',
        bio: 'Love traveling and coffee ☕',
        location: 'New York',
        image: '',
        photoUrl: null,
        email: '${names[index].toLowerCase().replaceAll(' ', '')}@example.com',
        phoneNumber: '+1234567${index.toString().padLeft(3, '0')}',
        online: true,
        lastSeen: '2 min ago',
        isVerified: true,
        createdAt: DateTime.now().subtract(Duration(days: 30 - index)),
        updatedAt: DateTime.now(),
        isSuperLover: index % 2 == 0,
      );

      final lastMessage = Message(
        id: 'msg_$index',
        text: messages[index],
        timestamp: times[index],
        isFromMe: false,
        isRead: index % 2 == 0,
        type: MessageType.text,
      );

      return Conversation(
        id: 'conv_$index',
        participant: user,
        lastMessage: lastMessage,
        lastActivity: times[index],
        unreadCount: index % 2 == 0 ? 0 : 1,
        isOnline: true,
      );
    });
  }

  static List<Message> getMockMessages(String conversationId) {
    return [
      Message(
        id: '1',
        text: 'Hey! How are you doing? 😊',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isFromMe: false,
        isRead: true,
      ),
      Message(
        id: '2',
        text: 'Hi! I\'m doing great, thanks for asking! How about you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        isFromMe: true,
        isRead: true,
      ),
      Message(
        id: '3',
        text: 'I\'m good too! Would you like to grab coffee sometime? ☕',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isFromMe: false,
        isRead: true,
      ),
      Message(
        id: '4',
        text: 'That sounds wonderful! I\'d love to meet you 💕',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isFromMe: true,
        isRead: true,
      ),
      Message(
        id: '5',
        text: 'Great! How about tomorrow at 3 PM?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isFromMe: false,
        isRead: false,
      ),
    ];
  }

  static Future<List<Conversation>> getConversations() async {
    try {
      // In a real app, this would fetch from API or local database
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      return getMockConversations();
    } catch (e) {
      Logger.error('Failed to fetch conversations', e);
      return [];
    }
  }

  static Future<List<Message>> getMessages(String conversationId) async {
    try {
      // In a real app, this would fetch from API or local database
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
      return getMockMessages(conversationId);
    } catch (e) {
      Logger.error('Failed to fetch messages', e);
      return [];
    }
  }

  static Future<void> sendMessage(String conversationId, String text) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        timestamp: DateTime.now(),
        isFromMe: true,
        isRead: false,
        type: MessageType.text,
      );

      // In a real app, this would send to API
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Add to local storage
      if (!_messages.containsKey(conversationId)) {
        _messages[conversationId] = [];
      }
      _messages[conversationId]!.add(message);
      
      Logger.info('Message sent: ${message.id}');
    } catch (e) {
      Logger.error('Failed to send message', e);
      rethrow;
    }
  }

  static Future<void> markAsRead(String conversationId, String messageId) async {
    try {
      // In a real app, this would update the API
      await Future.delayed(const Duration(milliseconds: 100));
      Logger.info('Message marked as read: $messageId');
    } catch (e) {
      Logger.error('Failed to mark message as read', e);
    }
  }

  static Future<void> deleteMessage(String conversationId, String messageId) async {
    try {
      // In a real app, this would delete from API
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Remove from local storage
      if (_messages.containsKey(conversationId)) {
        _messages[conversationId]!.removeWhere((msg) => msg.id == messageId);
      }
      
      Logger.info('Message deleted: $messageId');
    } catch (e) {
      Logger.error('Failed to delete message', e);
      rethrow;
    }
  }

  static Future<void> sendVoiceMessage(String conversationId, Duration duration) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Voice message',
        timestamp: DateTime.now(),
        isFromMe: true,
        isRead: false,
        type: MessageType.voice,
        voiceDuration: duration,
      );

      // In a real app, this would upload audio file and send to API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Add to local storage
      if (!_messages.containsKey(conversationId)) {
        _messages[conversationId] = [];
      }
      _messages[conversationId]!.add(message);
      
      Logger.info('Voice message sent: ${message.id}');
    } catch (e) {
      Logger.error('Failed to send voice message', e);
      rethrow;
    }
  }

  static Future<void> sendImageMessage(String conversationId, String imageUrl) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Image',
        timestamp: DateTime.now(),
        isFromMe: true,
        isRead: false,
        type: MessageType.image,
        mediaUrl: imageUrl,
      );

      // In a real app, this would upload image and send to API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Add to local storage
      if (!_messages.containsKey(conversationId)) {
        _messages[conversationId] = [];
      }
      _messages[conversationId]!.add(message);
      
      Logger.info('Image message sent: ${message.id}');
    } catch (e) {
      Logger.error('Failed to send image message', e);
      rethrow;
    }
  }

  static void addConversation(Conversation conversation) {
    _conversations.insert(0, conversation);
    Logger.info('Conversation added: ${conversation.id}');
  }

  static void updateConversation(String conversationId, Conversation updatedConversation) {
    final index = _conversations.indexWhere((conv) => conv.id == conversationId);
    if (index != -1) {
      _conversations[index] = updatedConversation;
      Logger.info('Conversation updated: $conversationId');
    }
  }

  static int getUnreadCount() {
    return _conversations.fold(0, (sum, conversation) => sum + conversation.unreadCount);
  }
}
