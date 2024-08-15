import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Data/Network_service/network_data.dart';
import 'package:neu_social/Utils/conversation/conversation_utils.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;

// Define states
abstract class WebSocketState {}

class WebSocketInitial extends WebSocketState {}

class WebSocketLoading extends WebSocketState {}

class WebSocketConnected extends WebSocketState {
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

  @override
  void emit(WebSocketState state) {
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

  Future<void> getConversations() async {
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
      final sstate = state as WebSocketConnected;
      final updatedConversations = updateMessageStatus(
          sstate.conversations, conversationId, messageId, status, '', '');
      initialConversations = updatedConversations;
      emit(WebSocketConnected(updatedConversations));
    }
  }

  void processSentMessage(Message message) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;
      final updatedConversations =
          addMessageToConversation(sstate.conversations, message);
      initialConversations = updatedConversations;
      emit(WebSocketConnected(updatedConversations));
    }
  }

  void processSendingMessage(String roomId, String receiverId, String content) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;
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
      emit(WebSocketConnected(updatedConversations));
    }
  }

  void processSentReceipt(String messageId, String roomId) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;
      final updatedConversations =
          updateAllMessagesToReceived(sstate.conversations, roomId);
      initialConversations = updatedConversations;
      emit(WebSocketConnected(updatedConversations));
    }
  }

  void processReceivedMessage(Message message) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;
      final updatedConversations =
          addMessageToConversation(sstate.conversations, message);
      initialConversations = updatedConversations;
      emit(WebSocketConnected(updatedConversations));
    }
  }

  void processReceivedAll(String conversationId) {
    if (state is WebSocketConnected) {
      final sstate = state as WebSocketConnected;
      final updatedConversations =
          updateAllMessagesToReceived(sstate.conversations, conversationId);
      initialConversations = updatedConversations;
      emit(WebSocketConnected(updatedConversations));
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

      return filteredUsers;
    }
    return [];
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
      if (state is WebSocketConnected) {
        initialConversations = (state as WebSocketConnected).conversations;
      }
      emit(WebSocketDisconnected(initialConversations));
    });
  }
}
