import '../../../shared/models/user_profile.dart';

class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isFromMe;
  final bool isRead;
  final MessageType type;
  final String? mediaUrl;
  final Duration? voiceDuration;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isFromMe,
    this.isRead = false,
    this.type = MessageType.text,
    this.mediaUrl,
    this.voiceDuration,
  });
}

enum MessageType {
  text,
  image,
  emoji,
  voice,
  file,
}

class Conversation {
  final String id;
  final UserProfile participant;
  final Message? lastMessage;
  final DateTime lastActivity;
  final int unreadCount;
  final bool isOnline;

  Conversation({
    required this.id,
    required this.participant,
    this.lastMessage,
    required this.lastActivity,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class ChatRoom {
  final String id;
  final List<UserProfile> participants;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime lastActivity;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.lastActivity,
  });
}
