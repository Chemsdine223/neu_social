import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Layouts/users_skeleton.dart';
import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';
import 'package:neu_social/Logic/SearchCubit/search_cubit.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Widgets/Inputs/custom_text_field.dart';

class UserSearchBottomSheet extends StatefulWidget {
  const UserSearchBottomSheet({super.key});

  @override
  State<UserSearchBottomSheet> createState() => _UserSearchBottomSheetState();
}

class _UserSearchBottomSheetState extends State<UserSearchBottomSheet> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Form(
            key: formkey,
            child: Column(
              children: [
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter a search query';
                    }
                    return null;
                  },
                  focusNode: focusNode,
                  controller: searchController,
                  hintText: 'search for user',
                ),
                BlocConsumer<SearchCubit, SearchState>(
                  listener: (context, state) {
                    if (state is SearchLoaded) {
                      if (state.users.isEmpty) {
                        errorSnackBar(context, 'No users match your query');
                      }
                    }
                    if (state is SearchError) {
                      errorSnackBar(
                          context, 'An error occured during your search');
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchLoaded) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    context
                                        .read<ChatCubit>()
                                        .createConversation(
                                            (state as AuthSuccess).user, user);
                                  },
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: const CircleAvatar(),
                                  title: Text(user.email),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is SearchLoading) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            return const UsersSkeleton();
                          },
                        ),
                      );
                    } else if (state is SearchError) {
                      return const Center(
                        child: Text('An error occured'),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                print(searchController.text);
                if (formkey.currentState!.validate()) {
                  context
                      .read<SearchCubit>()
                      .searchUsers(searchController.text);
                }
              },
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }
}
