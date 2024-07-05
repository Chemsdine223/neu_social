// conversation_utils.dart

import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/message.dart';

// Find conversation index by id
int findConversationIndex(
    List<Conversation> conversations, String conversationId) {
  return conversations.indexWhere((c) => c.id == conversationId);
}

// Find conversation by id
Conversation? findConversation(
    List<Conversation> conversations, String conversationId) {
  final index = findConversationIndex(conversations, conversationId);
  if (index != -1) {
    return conversations[index];
  }
  return null;
}

// Update message status in conversation
List<Conversation> updateMessageStatus(List<Conversation> conversations,
    String conversationId, String messageId, String status) {
  final index = findConversationIndex(conversations, conversationId);
  if (index != -1) {
    final conversation = conversations[index];

    final messageIndex = conversation.messages
        .indexWhere((m) => status == 'sent' ? m.id == 'id' : m.id == messageId);

    if (messageIndex != -1) {
      final updatedMessage = conversation.messages[messageIndex]
          .copyWith(status: status, id: messageId);
      final updatedMessages = List<Message>.from(conversation.messages)
        ..[messageIndex] = updatedMessage;
      final updatedConversation =
          conversation.copyWith(messages: updatedMessages);
      final updatedConversations = List<Conversation>.from(conversations)
        ..[index] = updatedConversation;
      return updatedConversations;
    }
  }
  return conversations;
}

// Add message to conversation
List<Conversation> addMessageToConversation(
    List<Conversation> conversations, Message message) {
  final conversationId = message.roomId;
  final index = findConversationIndex(conversations, conversationId);
  if (index != -1) {
    conversations[index].messages.add(message);
  } else {
    conversations.add(Conversation(
      id: conversationId,
      messages: [message],
      users: [], // Assuming users are already managed elsewhere
    ));
  }
  return List.from(conversations);
}

// Update all messages in conversation to "received" status
List<Conversation> updateAllMessagesToReceived(
    List<Conversation> conversations, String conversationId) {
  final index = findConversationIndex(conversations, conversationId);
  if (index != -1) {
    final updatedMessages = conversations[index].messages.map((message) {
      if (message.status != 'read') {
        return message.copyWith(status: 'received');
      }
      return message;
    }).toList();

    final updatedConversation =
        conversations[index].copyWith(messages: updatedMessages);
    final List<Conversation> updatedConversations = List.from(conversations)
      ..[index] = updatedConversation;
    return updatedConversations;
  }
  return conversations;
}


bool conversationExists(String senderId, String receiverId, List<Conversation> conversations) {
  for (var conversation in conversations) {
    bool senderInConversation = conversation.users.any((user) => user.id == senderId);
    bool receiverInConversation = conversation.users.any((user) => user.id == receiverId);
    if (senderInConversation && receiverInConversation) {
      return true;
    }
  }
  return false;
}


sortConversations() {
  
}