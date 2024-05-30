import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';

class CommunityPosts extends StatelessWidget {
  final Community community;
  const CommunityPosts({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            final listCommunity = state.communities
                .where((comm) => community.id == comm.id)
                .first;
            return ListView.builder(
              reverse: true,
              itemCount: listCommunity.posts.length,
              itemBuilder: (context, index) {
                final post = listCommunity.posts[index];
                return ListTile(
                  trailing: community.creator == post.user
                      ? const Icon(Icons.person)
                      : null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'Img/comments.png',
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.user.firstname} ${post.user.lastname}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // title: Text('${post.user.firstname} ${post.user.lastname}'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 26.0),
                    child: Text(
                      post.post,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
