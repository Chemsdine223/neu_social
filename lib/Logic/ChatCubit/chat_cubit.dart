// // import 'dart:io';

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Data/Network_service/network_data.dart';
import 'package:neu_social/Utils/conversation/conversation_utils.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    connectAndListen();
  }

  List<Conversation> initialConversations = [];

  @override
  void emit(ChatState state) {
    if (!isClosed) {
      super.emit(state);
    } else {
      print('Attempted to emit state on a closed Cubit');
    }
  }

  Socket socket = manager.io(
    socketUrl,
    OptionBuilder().setTransports(['websocket']).build(),
  );

  void sendReadStatus(String messageId, String roomId, String senderId) {
    socket.emit(
        'read',
        jsonEncode({
          "messageId": messageId,
          "senderId": senderId,
          "roomId": roomId,
        }));
  }

  Future<void> getConversations() async {
    emit(ChatLoading());
    try {
      final conversations = await NetworkData().getConversations();

      print(conversations);
      initialConversations = conversations;
      emit(Connected(conversations));
    } catch (e) {
      emit(Disconnected(initialConversations));
    }
  }

  void messageStatus(
      String messageId, String status, String conversationId) async {
    if (state is Connected) {
      final sstate = state as Connected;
      final updatedConversations = updateMessageStatus(
        sstate.conversations,
        conversationId,
        messageId,
        status,
      );
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  void processSentMessage(Message message) {
    if (state is Connected) {
      final sstate = state as Connected;
      final updatedConversations =
          addMessageToConversation(sstate.conversations, message);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  void processSendingMessage(String roomId, String receiverId, String content) {
    if (state is Connected) {
      final sstate = state as Connected;
      final message = Message(
        id: "id",
        senderId: NetworkService.id,
        receiverId: receiverId,
        roomId: roomId,
        content: content,
        status: "unsent",
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );
      final updatedConversations =
          addMessageToConversation(sstate.conversations, message);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  void processSentReceipt(String messageId, String roomId) {
    if (state is Connected) {
      final sstate = state as Connected;
      final updatedConversations =
          updateAllMessagesToReceived(sstate.conversations, roomId);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  void processRoomCreated(Map<String, dynamic> data) {
    if (state is Connected) {
      final newConversation = Conversation.fromMap(data['room']);
      final sstate = state as Connected;
      final updatedConversations = List<Conversation>.from(sstate.conversations)
        ..insert(0, newConversation);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  // void createRoom() {
  //   if (state is Connected) {
  //     final sstate = state as Connected;
  //     final updatedConversations =
  //   }
  // }

  void createConversation(UserModel sender, UserModel receiver) {
    if (state is Connected) {
      if (conversationExists(
          sender.id, receiver.id, (state as Connected).conversations)) {
        print(
            'Conversation already exists between ${sender.firstname} and ${receiver.firstname}');
        return;
      }

      socket.emit(
        'createRoom',
        jsonEncode(
          {
            "roomId": generateRandomString(24),
            "receiver": {
              "_id": receiver.id,
              "email": receiver.email,
              "dob": receiver.dob,
              "firstname": receiver.firstname,
              "lastname": receiver.lastname,
            },
            "sender": {
              "_id": sender.id,
              "email": sender.email,
              "dob": sender.dob,
              "firstname": sender.firstname,
              "lastname": sender.lastname,
            }
          },
        ),
      );
    }
  }

  void processReceivedMessage(Message message) {
    if (state is Connected) {
      final sstate = state as Connected;
      final updatedConversations =
          addMessageToConversation(sstate.conversations, message);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  void processReceivedAll(String conversationId) {
    if (state is Connected) {
      final sstate = state as Connected;
      final updatedConversations =
          updateAllMessagesToReceived(sstate.conversations, conversationId);
      initialConversations = updatedConversations;
      emit(Connected(updatedConversations));
    }
  }

  List<UserModel> getUsersExcludingCurrent() {
    if (state is Connected) {
      final currentState = state as Connected;
      List<UserModel> filteredUsers = [];

      for (var conversation in currentState.conversations) {
        final usersInConversation = conversation.users
            .where((user) => user.id != NetworkService.id)
            .toList();
        filteredUsers.addAll(usersInConversation);
      }

      return filteredUsers;
    }
    return [];
  }

  disconnectSocket() {
    socket.dispose();
    socket.destroy();
  }

  void sendMessage(String content, String roomId, String receiverId) {
    socket.emit(
        'message',
        jsonEncode({
          "content": content,
          "senderId": NetworkService.id,
          "receiverId": receiverId,
          "roomId": roomId,
        }));
    processSendingMessage(roomId, receiverId, content);
  }

  void connectAndListen() async {
    await getConversations();
    await NetworkService.loadTokens();

    print(NetworkService.id);

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
      print('This is the message');
      processReceivedMessage(message);

      socket.emit(
        'received',
        jsonEncode(
          {
            "messageId": message.id,
            "roomId": message.roomId,
            "senderId": message.senderId,
          },
        ),
      );
    });

    socket.onAny((event, data) {
      log('On any: $event');
    });

    socket.on('roomCreated', (data) {
      processRoomCreated(data);
    });

    socket.on('receivedAll', (data) {
      processReceivedAll(data['room']);
    });

    socket.on('read', (data) {
      messageStatus(data['messageId'], "read", data['roomId']);
    });

    socket.on('received', (data) {
      messageStatus(data['messageId'], "received", data['roomId']);
    });

    socket.onAny((event, data) {
      log(event);
      log(data.toString());
    });

    socket.on('sent', (data) {
      messageStatus(data['messageId'], 'sent', data['roomId']);
    });

    socket.onDisconnect((_) {
      if (state is Connected) {
        initialConversations = (state as Connected).conversations;
      }
      emit(Disconnected(initialConversations));
    });
  }
}
