class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String messageText;
  final String messageType;
  final String? mediaUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final Map<String, dynamic>? sender;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.messageType,
    this.mediaUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      messageText: json['message_text'],
      messageType: json['message_type'],
      mediaUrl: json['media_url'],
      isRead: json['is_read'],
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_text': messageText,
      'message_type': messageType,
      'media_url': mediaUrl,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'sender': sender,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? messageText,
    String? messageType,
    String? mediaUrl,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    Map<String, dynamic>? sender,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      messageText: messageText ?? this.messageText,
      messageType: messageType ?? this.messageType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      sender: sender ?? this.sender,
    );
  }
}
