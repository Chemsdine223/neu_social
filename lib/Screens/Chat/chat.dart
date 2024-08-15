import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Layouts/users_skeleton.dart';
import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';
import 'package:neu_social/Logic/SearchCubit/search_cubit.dart';
import 'package:neu_social/Screens/Chat/room.dart';
import 'package:neu_social/Utils/conversation/date_time_format.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/BottomSheets/user_search_bottom_sheet.dart';

class WebSocketScreen extends StatelessWidget {
  const WebSocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () {
                    showBottomSheet(
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return BlocProvider(
                          create: (context) => SearchCubit(),
                          child: const UserSearchBottomSheet(),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add));
            },
          )
        ],
        centerTitle: true,
        title: const Text('Chats'),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is Connected) {
            var sortedConversations = List.of(state.conversations);

            sortedConversations.sort(
              (a, b) {
                // Compare messages if both have messages
                if (a.messages.isNotEmpty && b.messages.isNotEmpty) {
                  return b.messages.last.createdAt
                      .compareTo(a.messages.last.createdAt);
                }
                // Handle cases where one or both have no messages
                if (a.messages.isEmpty && b.messages.isEmpty) {
                  return b.createdAt.compareTo(a.createdAt);
                }
                if (a.messages.isEmpty) {
                  return b.messages.last.createdAt.compareTo(a.createdAt);
                }
                return b.createdAt.compareTo(a.messages.last.createdAt);
              },
            );

            return RefreshIndicator(
              onRefresh: () => context.read<ChatCubit>().getConversations(),
              child: ListView.builder(
                itemCount: sortedConversations.length,
                itemBuilder: (context, index) {
                  final conversation = sortedConversations[index];
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
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        conversation.messages.isNotEmpty
                            ? Text(
                                DateTime.parse(conversation
                                                .messages.last.createdAt)
                                            .day ==
                                        DateTime.now().day
                                    ? formatTime(
                                        conversation.messages.last.createdAt)
                                    : formatDate(
                                        conversation.messages.last.createdAt),
                              )
                            : const Text(''),
                        conversation.messages
                                .where((element) =>
                                    element.status != "read" &&
                                    element.senderId != NetworkService.id)
                                .isEmpty
                            ? const SizedBox(height: 0, width: 0)
                            : CircleAvatar(
                                radius: getProportionateScreenHeight(12),
                                child: Text(
                                  conversation.messages
                                      .where((element) =>
                                          element.status != "read" &&
                                          element.senderId != NetworkService.id)
                                      .length
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                ),
                              ),
                      ],
                    ),
                    title: Text(
                      conversation.users
                          .where((element) => element.id != NetworkService.id)
                          .first
                          .email,
                    ),
                    subtitle: conversation.messages.isNotEmpty
                        ? Text(conversation.messages.last.content)
                        : const Text(''),
                  );
                },
              ),
            );
          }
          if (state is Disconnected) {
            var sortedConversations = List.of(state.conversations);
            sortedConversations.sort((a, b) =>
                b.messages.last.createdAt.compareTo(a.messages.last.createdAt));

            return ListView.builder(
              itemCount: sortedConversations.length,
              itemBuilder: (context, index) {
                final conversation = sortedConversations[index];

                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Room(
                          roomId: conversation.id,
                        ),
                      )),
                  title: Text(conversation.messages.length.toString()),
                );
              },
            );
          }
          return ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) => const UsersSkeleton(),
          );
        },
      ),
    );
  }
}
