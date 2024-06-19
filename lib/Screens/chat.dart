import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';
import 'package:neu_social/Screens/room.dart';

class WebSocketScreen extends StatelessWidget {
  const WebSocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Example'),
      ),
      body: BlocBuilder<WebSocketCubit, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnected) {
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        roomId: conversation.id,
                      ),
                    ),
                  ),
                  leading: const CircleAvatar(),
                  trailing: Text(state.conversations[index].messages
                      .where((element) => element.status != "read")
                      .length
                      .toString()),

                  title: Text(
                    state.conversations[index].users
                        .where((element) => element.id != NetworkService.id)
                        .first
                        .email,
                  ),
                  subtitle:
                      Text(state.conversations[index].messages.last.content),
                  // trailing: icon,
                );
              },
            );
          }
          if (state is WebSocketDisconnected) {
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];

                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Room(
                          roomId: conversation.id,
                        ),
                      )),
                  title: Text(
                      state.conversations[index].messages.length.toString()),
                  // trailing: icon,
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
