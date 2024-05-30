import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Screens/CommunityDetails/community_events.dart';
import 'package:neu_social/Screens/CommunityDetails/community_posts.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Screens/CommunityDetails/community_info.dart';
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
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding:
                  EdgeInsets.only(right: getProportionateScreenWidth(10.0)),
              child: IconButton(
                  onPressed: () {
                    isSheetShowing == false
                        ? showBottomSheet(
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
      body: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // width: getProportionateScreenWidth(160),
                  height: getProportionateScreenHeight(40),
                  width: getProportionateScreenWidth(240),
                  child: ToggleButtonsWidget(
                    initialPostsState: posts,
                    onToggle: (value) {
                      setState(() {
                        posts = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            posts
                ? CommunityPosts(
                    community: widget.community,
                  )
                : CommunityEvents(
                    community: widget.community,
                  ),
            Container(
              // color: Colors.amber,
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                icon: InkWell(
                    onTap: () {
                      context
                          .read<HomeCubit>()
                          .createPost(widget.community, postController.text);
                      postController.clear();
                    },
                    child: Image.asset('Img/send.png', height: 20)),
                controller: postController,
                hintText: 'Speak your mind',
                password: false,
                validator: (p0) {
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
