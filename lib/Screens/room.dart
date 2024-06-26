import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';

import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';
import 'package:neu_social/Widgets/Misc/chat_bubble.dart';

class Room extends StatefulWidget {
  final String roomId;
  const Room({
    super.key,
    required this.roomId,
  });

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<WebSocketCubit, WebSocketState>(
          builder: (context, state) {
            if (state is WebSocketConnected) {
              final currentConversation = state.conversations
                  .where((element) => element.id == widget.roomId)
                  .first;
              final user = currentConversation.users
                  .where((element) => element.id != NetworkService.id)
                  .first;

              return Text("${user.firstname} ${user.lastname}");
            }
            return const Text('data');
          },
        ),
      ),
      body: BlocBuilder<WebSocketCubit, WebSocketState>(
        builder: (context, state) {
          if (state is WebSocketConnected) {
            final conversation = state.conversations
                .where((element) => element.id == widget.roomId)
                .first;
            final messages = conversation.messages.reversed.toList();
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message.status == 'sent' &&
                              message.senderId != NetworkService.id ||
                          message.status == 'received' &&
                              message.senderId != NetworkService.id) {
                        context.read<WebSocketCubit>().sendReadStatus(
                            message.id, conversation.id, message.senderId);
                      }

                      return ChatBubble(message: message);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(12),
                  ),
                  child: CustomTextField(
                    icon: InkWell(
                      onTap: () {
                        context.read<WebSocketCubit>().sendMessage(
                              postController.text,
                              conversation.id,
                              conversation.users
                                  .where((element) =>
                                      element.id != NetworkService.id)
                                  .first
                                  .id,
                            );
                        postController.clear();
                      },
                      child: Image.asset('Img/send.png', height: 20),
                    ),
                    controller: postController,
                    hintText: 'Send a message',
                    password: false,
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
