import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Screens/CommunityDetails/community_events.dart';
import 'package:neu_social/Screens/CommunityDetails/community_posts.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Screens/CommunityDetails/community_info.dart';
import 'package:neu_social/Widgets/BottomSheets/event_creation_sheet.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Buttons/toggle_button.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';

class CommunityDetails extends StatefulWidget {
  final Community community;
  const CommunityDetails({
    super.key,
    required this.community,
  });

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  bool posts = true;
  bool isSheetShowing = false;
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding:
                  EdgeInsets.only(right: getProportionateScreenWidth(10.0)),
              child: isSheetShowing
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        isSheetShowing == false
                            ? showBottomSheet(
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return CommunityInfo(
                                    id: widget.community.id,
                                  );
                                },
                              )
                            : Navigator.pop(context);
                        setState(() {
                          isSheetShowing = !isSheetShowing;
                        });
                      },
                      icon: const Icon(Icons.info_outline)),
            );
          }),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: getProportionateScreenWidth(56),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  isSheetShowing = !isSheetShowing;
                });
              },
              child: const Icon(Icons.arrow_back_ios),
            );
          }),
        ),
        title: Text(widget.community.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: getProportionateScreenHeight(40),
                width: getProportionateScreenWidth(240),
                child: widget.community.type.toLowerCase() != 'invitation-based'
                    ? ToggleButtonsWidget(
                        initialPostsState: posts,
                        onToggle: (value) {
                          setState(() {
                            posts = value;
                          });
                        },
                      )
                    : Container(),
              ),
            ],
          ),
          posts
              ? Expanded(
                  child: CommunityPosts(
                    community: widget.community,
                  ),
                )
              : Expanded(
                  child: CommunityEvents(
                    community: widget.community,
                  ),
                ),
          // const Text('data'),
          posts
              ? BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      final community = state.communities
                          .where((c) => c.id == widget.community.id)
                          .first;
                      return community.users.contains(state.user)
                          ? Container(
                              // color: Colors.amber,
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                icon: InkWell(
                                    onTap: () {
                                      if (postController.text.isNotEmpty) {
                                        context.read<HomeCubit>().createPost(
                                            widget.community,
                                            postController.text);
                                        postController.clear();
                                      }
                                    },
                                    child: Image.asset('Img/send.png',
                                        height: 20)),
                                controller: postController,
                                hintText: 'Speak your mind',
                                password: false,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                onTap: () {
                                  context
                                      .read<HomeCubit>()
                                      .joinCommunity(community);
                                  successSnackBar(context,
                                      'You are now a part of this community !');
                                },
                                color: Theme.of(context).colorScheme.secondary,
                                radius: 12,
                                height: getProportionateScreenHeight(40),
                                label: Text(
                                  'Join to post',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            );
                    }
                    return Container();
                  },
                )
              : Container(),
        ],
      ),
      floatingActionButton: !posts && !isSheetShowing
          ? Builder(builder: (context) {
              return BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'Img/calendar.png',
                      height: getProportionateScreenHeight(26),
                    ),
                    onPressed: () {
                      if (state is HomeLoaded) {
                        final currentCommunity = state.communities
                            .where((c) => c.id == widget.community.id)
                            .first;
                        if (!currentCommunity.users.contains(state.user)) {
                          errorSnackBar(context,
                              'You should join the community to post events');
                        } else {
                          setState(() {
                            isSheetShowing = !isSheetShowing;
                          });
                          showBottomSheet(
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return CreateEventSheet(
                                communityId: widget.community.id,
                              );
                            },
                          );
                        }
                      }
                    },
                  );
                },
              );
            })
          : null,
    );
  }
}
