// // import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:neu_social/Constants/constants.dart';
// import 'package:neu_social/Data/Models/conversation.dart';
// import 'package:neu_social/Data/Models/message.dart';
// import 'package:socket_io_client/socket_io_client.dart';

// part 'chat_state.dart';

// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(ChatInitial()) {
//     connectAndListen();
//   }

//   Socket socket = io(
//     baseUrl,
//     OptionBuilder()
//         .setTransports(['websocket']).setExtraHeaders({"id": "123456"}).build(),
//   );

//   void connectAndListen() {
//     socket.onConnect((_) {
//       emit(Connected([]));
//     });

//     socket.on('message', (data) {
//       print('Message received: $data');
//       final message = Message.fromMap(data);

//       if (state is Connected) {
//         final currentState = state as Connected;
//         currentState.conversations.add(message);

//         emit(Connected(List.from(currentState.messages)));

//         // Check if message is already in the list to prevent duplicates
//       }
//     });

//     socket.on('receivedAll', (data) {
//       print('Read event received: $data');
//       if (state is WebSocketConnected) {
//         final currentState = state as WebSocketConnected;

//         // Update the status of all messages to "read"
//         final updatedMessages = currentState.messages.map((message) {
//           print(message);
//           return message.copyWith(status: 'received');
//         }).toList();

//         // Emit a new state with the updated messages list
//         emit(WebSocketConnected(updatedMessages));
//       }
//     });

//     socket.on('read', (data) {
//       print('Read event received: $data');
//       if (state is WebSocketConnected) {
//         final currentState = state as WebSocketConnected;

//         // Update the status of all messages to "read"
//         final updatedMessages = currentState.messages.map((message) {
//           print(message);
//           return message.copyWith(status: 'read');
//         }).toList();

//         // Emit a new state with the updated messages list
//         emit(WebSocketConnected(updatedMessages));
//       }
//     });

//     socket.onAny((event, data) {
//       print(event);
//       // print(data);
//     });

//     socket.onDisconnect((_) {
//       emit(WebSocketDisconnected());
//     });
//   }
// }
