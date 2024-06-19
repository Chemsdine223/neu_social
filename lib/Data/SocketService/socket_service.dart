import 'package:neu_social/Constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  Socket socket = io(
    baseUrl,
    OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect()
        .build(),
  );

  connectToSocket() {
    socket.connect();
    // socket.connected ? print('Yes') : print('No');
  }

  readMessage() {
    socket.emit('read');
    // socket.on('read', (data) => print('read message'));
  }
}
