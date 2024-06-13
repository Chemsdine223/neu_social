// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/message.dart';
// import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as manager;

// Define states
abstract class WebSocketState {}

class WebSocketInitial extends WebSocketState {}

class WebSocketConnected extends WebSocketState {
  final List<Message> messages;

  WebSocketConnected(this.messages);
}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketDataReceived extends WebSocketState {
  final List<Message> messages;

  WebSocketDataReceived(this.messages);
}

// Define Cubit
class WebSocketCubit extends Cubit<WebSocketState> {
  WebSocketCubit() : super(WebSocketInitial()) {
    connectAndListen();
  }

  void connectAndListen() async {
    Socket socket = manager.io(
      socketUrl,
      OptionBuilder().setTransports(['websocket']).build(),
    );

    // String id = NetworkService.id;
    socket.io.options!['extraHeaders'] = {
      "id": "6669804bd7bad1fe82c5fbbc",
    };

    socket
      ..disconnect()
      ..connect();

    // List<Message> defaultMessages = await StorageService.loadMessages();

    // print(defaultMessages);

    socket.onConnect((_) {
      emit(WebSocketConnected([]));
    });

    socket.on('message', (data) {
      print('Message received: $data');
      final message = Message.fromMap(data['message']);
      
      // socket.emit('received', (data) {
      // !  jsonEncode('send the message id and the receiver id back');
      // });

      if (state is WebSocketConnected) {
        final currentState = state as WebSocketConnected;
        currentState.messages.add(message);
        // defaultMessages.add(message);

        emit(WebSocketConnected(List.from(currentState.messages)));

        // Check if message is already in the list to prevent duplicates
      }
    });

    socket.on('receivedAll', (data) {
      print('Read event received: $data');
      if (state is WebSocketConnected) {
        final currentState = state as WebSocketConnected;

        // Update the status of all messages to "read"
        final updatedMessages = currentState.messages.map((message) {
          print(message);
          return message.copyWith(status: 'received');
        }).toList();

        // Emit a new state with the updated messages list
        emit(WebSocketConnected(updatedMessages));
      }
    });

    socket.on('read', (data) {
      if (state is WebSocketConnected) {
        final currentState = state as WebSocketConnected;
        final id = data['messageId'];

        // Update the status of the message with the corresponding ID
        final updatedMessages = currentState.messages.map((message) {
          if (message.id == id) {
            return message.copyWith(status: 'read');
          } else {
            print('No: ${message.id}');
            return message;
          }
        }).toList();

        // Emit a new state with the updated messages list
        emit(WebSocketConnected(updatedMessages));
      }
    });

    // socket.vola

    socket.onAny((event, data) {
      print(event);
      // print(data);
    });

    socket.onDisconnect((_) {
      // StorageService.saveMessages(defaultMessages);
      // emit(WebSocketDisconnected());
    });
  }
}
