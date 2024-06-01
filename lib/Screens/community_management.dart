import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Screens/CommunityDetails/community_details.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Widgets/Cards/community_card.dart';

class ManageCommunities extends StatefulWidget {
  const ManageCommunities({super.key});

  @override
  State<ManageCommunities> createState() => _ManageCommunitiesState();
}

class _ManageCommunitiesState extends State<ManageCommunities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Community management'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final homeCubitt = BlocProvider.of<HomeCubit>(context);
          if (state is HomeLoaded) {
            return ListView.builder(
              itemCount:
                  findUserCommunities(state.communities, state.user).length,
              itemBuilder: (context, index) {
                final communityList =
                    findUserCommunities(state.communities, state.user);
                final community = communityList[index];

                return CommunityCard(
                  community: community,
                  clickable: true,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: homeCubitt,
                          child: CommunityDetails(community: community),
                        ),
                      )),
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
