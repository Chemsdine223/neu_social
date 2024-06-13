import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';

class WebSocketScreen extends StatelessWidget {
  const WebSocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<WebSocketCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Example'),
      ),
      body: BlocBuilder<WebSocketCubit, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnected) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                Icon? icon;

                switch (state.messages[index].status) {
                  case 'read':
                    icon = const Icon(
                      Icons.done_all,
                      color: Colors.blue,
                    );
                    break;
                  case 'received':
                    icon = const Icon(Icons.done_all);
                    break;
                  case 'sent':
                    icon = const Icon(Icons.done);
                    break;
                  default:
                }

                return ListTile(
                  title: Text(state.messages[index].content),
                  trailing: icon,
                );
              },
            );
          }
          if (state is WebSocketDisconnected) {
            return const Center(child: Text('Disconnected'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';
// import 'package:neu_social/Screens/room.dart';

// class Chat extends StatefulWidget {
//   const Chat({super.key});

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChatCubit(),
//       child: BlocBuilder<ChatCubit, ChatState>(
//         builder: (context, state) {
//           return Scaffold(
//             body: ListView.builder(
//               itemCount: 12,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Room(),
//                       )),
//                   title: Text('Conversation $index'),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
