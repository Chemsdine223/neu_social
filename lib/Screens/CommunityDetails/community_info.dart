import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';

class CommunityInfo extends StatelessWidget {
  final int id;
  const CommunityInfo({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          final community = state.communities.where((c) => c.id == id).first;
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(12),
              vertical: getProportionateScreenHeight(12),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          fit: BoxFit.contain,
                          community.image == ""
                              ? "Img/social-media.png"
                              : community.image),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Text(
                  community.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: getProportionateScreenHeight(32)),
                Text(
                  'This groups members are interested by: ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  community.interests
                      .map((e) => e)
                      .toList()
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", ""),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'Img/group-users.png',
                          height: getProportionateScreenHeight(28),
                          color: Theme.of(context).primaryColor,
                        ),
                        const Text('Community members')
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(12)),
                Expanded(
                  child: GridView.builder(
                    itemCount: community.users.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (context, index) {
                      final user = community.users[index];
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            textAlign: TextAlign.center,
                            '${user.firstname} ${user.lastname}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                !community.users.contains(state.user)
                    ? CustomButton(
                        onTap: () {
                          context.read<HomeCubit>().joinCommunity(community);
                          successSnackBar(context,
                              'You are now a part of this community !');
                        },
                        color: Theme.of(context).colorScheme.secondary,
                        radius: 12,
                        height: getProportionateScreenHeight(40),
                        label: Text(
                          'Join',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
