// import 'dart:convert';
// import 'dart:developer';

// import 'dart:developer';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Data/Network_service/network_data.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;

// Define states
abstract class WebSocketState {}

class WebSocketInitial extends WebSocketState {}

class WebSocketLoading extends WebSocketState {}

class WebSocketConnected extends WebSocketState {
  // final List<Message> messages;
  final List<Conversation> conversations;

  WebSocketConnected(this.conversations);
}

class WebSocketDisconnected extends WebSocketState {
  final List<Conversation> conversations;

  WebSocketDisconnected(this.conversations);
}

class WebSocketDataReceived extends WebSocketState {
  final List<Message> messages;

  WebSocketDataReceived(this.messages);
}

// Define Cubit
class WebSocketCubit extends Cubit<WebSocketState> {
  WebSocketCubit() : super(WebSocketInitial()) {
    connectAndListen();
  }

  Socket socket = manager.io(
    socketUrl,
    OptionBuilder().setTransports(['websocket']).build(),
  );

  List<Conversation> initialConversations = [];

  void sendReadStatus(String messageId, String roomId, String senderId) {
    socket.emit(
        'read',
        jsonEncode({
          "messageId": messageId,
          "senderId": senderId,
          "roomId": roomId,
        }));
  }

  getConversations() async {
    try {
      final conversations = await NetworkData().getConversations();
      initialConversations = conversations;
      emit(WebSocketConnected(conversations));
    } catch (e) {
      emit(WebSocketDisconnected(initialConversations));
    }
  }

  void messageStatus(
      String messageId, String status, String conversationId) async {
    if (state is WebSocketConnected) {
      log('here I am ');
      final sstate = state as WebSocketConnected;

      final existingIndex =
          sstate.conversations.indexWhere((c) => c.id == conversationId);

      if (existingIndex != -1) {
        final conversation = sstate.conversations[existingIndex];
        final messageIndex =
            conversation.messages.indexWhere((m) => m.id == messageId);

        if (messageIndex != -1) {
          final updatedMessage =
              conversation.messages[messageIndex].copyWith(status: status);

          final updatedMessages = List<Message>.from(conversation.messages)
            ..[messageIndex] = updatedMessage;

          final updatedConversation =
              conversation.copyWith(messages: updatedMessages);

          final updatedConversations =
              List<Conversation>.from(sstate.conversations)
                ..[existingIndex] = updatedConversation;

          emit(WebSocketConnected(updatedConversations));
        }
      }
    }
  }

  void processReceivedMessage(Message message) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;

      final conversationId = message.roomId;
      final existingIndex =
          sstate.conversations.indexWhere((c) => c.id == conversationId);
      final existingConversation =
          sstate.conversations.where((c) => c.id == conversationId).first;

      if (existingIndex != -1) {
        sstate.conversations[existingIndex].messages.add(message);
      } else {
        sstate.conversations.add(Conversation(
          id: conversationId,
          messages: [message],
          users: [existingConversation.users[0], existingConversation.users[1]],
        ));
      }

      emit(WebSocketConnected(
        List.from(
          sstate.conversations,
        ),
      ));
    }
  }

  void processReceivedAll(String conversationId) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;

      // Find the index of the conversation
      final existingIndex =
          sstate.conversations.indexWhere((c) => c.id == conversationId);

      if (existingIndex != -1) {
        // Update the status of all messages in the conversation to "received" if they are not "read"
        final updatedMessages =
            sstate.conversations[existingIndex].messages.map((message) {
          if (message.status != 'read') {
            return message.copyWith(status: 'received');
          }
          return message;
        }).toList();

        // Create a new conversation with the updated messages
        final updatedConversation = sstate.conversations[existingIndex]
            .copyWith(messages: updatedMessages);

        // Create a new list of conversations with the updated conversation
        final updatedConversations = List.from(sstate.conversations)
          ..[existingIndex] = updatedConversation;

        // Emit the new state with the updated conversations
        emit(WebSocketConnected(
          List.from(updatedConversations),
        ));
      }
    }
  }

  List<UserModel> getUsersExcludingCurrent() {
    if (state is WebSocketConnected) {
      final currentState = state as WebSocketConnected;
      List<UserModel> filteredUsers = [];

      for (var conversation in currentState.conversations) {
        final usersInConversation = conversation.users
            .where((user) => user.id != NetworkService.id)
            .toList();
        filteredUsers.addAll(usersInConversation);
      }

      print(filteredUsers[0]);

      return filteredUsers;
    }
    return [];
  }

  void connectAndListen() async {
    await getConversations();

    await NetworkService.loadTokens();

    socket.io.options!['extraHeaders'] = {
      "id": NetworkService.id,
    };

    socket
      ..disconnect()
      ..connect();

    socket.onConnect((_) {
      if (state is WebSocketConnected) {
        final currentState = state as WebSocketConnected;
        for (var conversation in currentState.conversations) {
          final filteredUsers = conversation.users
              .where((user) => user.id != NetworkService.id)
              .toList();
          for (var user in filteredUsers) {
            print(user.id);
            socket.emit(
              'receivedAll',
              jsonEncode({
                "roomId": conversation.id,
                "receiverId": user.id,
              }),
            );
          }
        }
      }
      emit(WebSocketConnected(initialConversations));
    });

    socket.on('message', (data) {
      final message = Message.fromMap(data['message']);
      processReceivedMessage(message);

      // print(message.senderId);
      // print(message.receiverId);

      socket.emit(
          'received',
          jsonEncode({
            "messageId": message.id,
            "roomId": message.roomId,
            "senderId": message.senderId,
          }));
    });

    socket.on('receivedAll', (data) {
      processReceivedAll(data['room']);
    });

    socket.on('read', (data) {
      print('read event: $data');
      messageStatus(data['messageId'], "read", data['roomId']);
    });

    socket.on('received', (data) {
      print('receivedEvent event: $data');
      messageStatus(data['messageId'], "received", data['roomId']);
    });

    socket.onAny((event, data) {
      log(event);
      log(data.toString());
    });

    socket.onDisconnect((_) {
      if (state is WebSocketConnected) {
        initialConversations = (state as WebSocketConnected).conversations;
      }
      emit(WebSocketDisconnected(initialConversations));
    });
  }
}
