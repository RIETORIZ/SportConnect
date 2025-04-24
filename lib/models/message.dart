// lib/models/message.dart

class DirectMessage {
  final int messageId;
  final int senderId;
  final int receiverId;
  final String messageText;
  final DateTime sentAt;
  String? senderName; // Not from DB, but useful for UI
  String? receiverName; // Not from DB, but useful for UI

  DirectMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.sentAt,
    this.senderName,
    this.receiverName,
  });

  factory DirectMessage.fromJson(Map<String, dynamic> json) {
    return DirectMessage(
      messageId: json['message_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      messageText: json['message_text'],
      sentAt: DateTime.parse(json['sent_at']),
      senderName: json['sender_name'],
      receiverName: json['receiver_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_text': messageText,
      'sent_at': sentAt.toIso8601String(),
    };
  }
}

// Helper class for chat conversations
class Conversation {
  final int userId; // The other person's ID
  final String userName; // The other person's name
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? userImageUrl;

  Conversation({
    required this.userId,
    required this.userName,
    this.lastMessage,
    this.lastMessageTime,
    this.userImageUrl,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['user_id'],
      userName: json['user_name'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'])
          : null,
      userImageUrl: json['user_image_url'],
    );
  }
}
