import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  Socket socket = io(
    'http://192.168.100.30:3000',
    OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
        .build(),
  );

  //When an event recieved from server, data is added to the stream
  // socket.emit('read');
  socket.on('read', (data) => streamSocket.addResponse);
  socket.onDisconnect((_) => print('disconnect'));
  socket.onConnect((data) => print('connected'));
  // socket.onAny((event, data) => print(event));
}
