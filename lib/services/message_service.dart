// lib/services/message_service.dart

import 'api_service.dart';
import '../models/message.dart';

class MessageService {
  // Get all conversations for the current user
  static Future<List<Conversation>> getConversations() async {
    return await ApiService.getConversations();
  }

  // Get conversation with a specific user
  static Future<List<DirectMessage>> getConversation(int userId) async {
    return await ApiService.getConversation(userId);
  }

  // Send a message to another user
  static Future<DirectMessage> sendMessage(
      int receiverId, String message) async {
    return await ApiService.sendMessage(receiverId, message);
  }
}
