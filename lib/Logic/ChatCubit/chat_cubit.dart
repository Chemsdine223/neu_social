// // import 'dart:io';

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Data/Network_service/network_data.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Conversation> initialConversations = [];

  Socket socket = manager.io(
    socketUrl,
    OptionBuilder().setTransports(['websocket']).build(),
  );

  void messageStatus(
      String messageId, String status, String conversationId) async {
    if (state is Connected) {
      log('here I am ');
      final sstate = state as Connected;

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

          emit(Connected(updatedConversations));
        }
      }
    }
  }

  void processReceivedMessage(Message message) {
    if (state is Connected) {
      final sstate = state as Connected;

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

      emit(Connected(
        List.from(
          sstate.conversations,
        ),
      ));
    }
  }

  void processReceivedAll(String conversationId) {
    if (state is Connected) {
      final sstate = state as Connected;

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
        emit(Connected(
          List.from(updatedConversations),
        ));
      }
    }
  }

  getConversations() async {
    try {
      final conversations = await NetworkData().getConversations();
      initialConversations = conversations;
      emit(Connected(conversations));
    } catch (e) {
      emit(Connected(initialConversations));
    }
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
      if (state is Connected) {
        final currentState = state as Connected;
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
      emit(Connected(initialConversations));
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
      if (state is Connected) {
        initialConversations = (state as Connected).conversations;
      }
      emit(Disconnected(initialConversations));
    });
  }
}
