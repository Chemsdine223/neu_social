import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';
import 'package:neu_social/Utils/Scroll/scroll_utilities.dart';
import 'package:neu_social/Utils/conversation/date_time_format.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';
import 'package:neu_social/Widgets/Misc/chat_bubble.dart';
import 'package:intl/intl.dart';

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
  final scroll = ScrollController();
  final node = FocusNode();

  List<dynamic> _prepareMessages(List<Message> messages) {
    List<dynamic> groupedMessages = [];
    String lastDate = '';

    for (var message in messages) {
      String messageDate = formatDate(message.createdAt);
      if (messageDate != lastDate) {
        groupedMessages.add(messageDate);
        lastDate = messageDate;
      }
      groupedMessages.add(message);
    }

    // Reverse the entire list to match the reversed ListView.builder
    return groupedMessages.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(scroll, null);
    });
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                int unreadMessagesCount = 0;
                if (state is Connected) {
                  unreadMessagesCount = state.conversations.fold(
                    0,
                    (count, conversation) {
                      return count +
                          conversation.messages
                              .where((message) =>
                                  message.status != 'read' &&
                                  message.senderId != NetworkService.id &&
                                  message.roomId != widget.roomId)
                              .length;
                    },
                  );

                  return unreadMessagesCount == 0
                      ? Container()
                      : Text(
                          unreadMessagesCount.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        );
                }
                return const Text('data');
              },
            ),
          ],
        ),
        centerTitle: true,
        title: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is Connected) {
              final currentConversation = state.conversations
                  .where((element) => element.id == widget.roomId)
                  .first;
              final user = currentConversation.users
                  .where((element) => element.id != NetworkService.id)
                  .first;
              return GestureDetector(
                  onTap: () => smoothScrollToTop(scroll),
                  child: Text("${user.firstname} ${user.lastname}"));
            }
            return const Text('data');
          },
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is Connected) {
            final conversation = state.conversations
                .where((element) => element.id == widget.roomId)
                .first;
            final messages = conversation.messages.toList();
            final groupedMessages = _prepareMessages(messages);

            return Stack(
              children: [
                SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        reverse: false,
                        shrinkWrap: true,
                        itemCount: groupedMessages.length,
                        itemBuilder: (context, index) {
                          final orederedGroupedMessages =
                              groupedMessages.reversed.toList();
                          final item = orederedGroupedMessages[index];
                          if (item is String) {
                            DateTime date = DateTime.parse(item);
                            DateTime now = DateTime.now();
                            DateTime yesterday =
                                now.subtract(const Duration(days: 1));

                            String displayDate;
                            if (date.year == yesterday.year &&
                                date.month == yesterday.month &&
                                date.day == yesterday.day) {
                              displayDate = 'Yesterday';
                            } else {
                              displayDate =
                                  DateFormat('dd-MM-yyyy').format(date);
                            }

                            // Date header
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  displayDate,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            );
                          } else if (item is Message) {
                            // Message bubble
                            final message = item;
                            if (message.status == 'sent' &&
                                    message.senderId != NetworkService.id ||
                                message.status == 'received' &&
                                    message.senderId != NetworkService.id) {
                              context.read<ChatCubit>().sendReadStatus(
                                  message.id,
                                  conversation.id,
                                  message.senderId);
                            }
                            return ChatBubble(message: message);
                          }
                          return Container();
                        },
                      ),
                      Container(
                        height: getProportionateScreenHeight(60),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomTextField(
                    // autoFocus: true,
                    icon: InkWell(
                      onTap: () {
                        if (postController.text.isNotEmpty) {
                          context.read<ChatCubit>().sendMessage(
                                postController.text,
                                conversation.id,
                                conversation.users
                                    .where((element) =>
                                        element.id != NetworkService.id)
                                    .first
                                    .id,
                              );
                          postController.clear();
                          smoothScrollToBottom(
                              scroll, getProportionateScreenHeight(60));
                        }

                        print(postController.text);
                        print(conversation.id);
                        print(conversation.users
                            .where((element) => element.id != NetworkService.id)
                            .first
                            .id);
                      },
                      child: Image.asset(
                        'Img/send.png',
                        height: getProportionateScreenHeight(20),
                      ),
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
