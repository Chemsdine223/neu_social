import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Data/Models/post.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Utils/helpers.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  AuthCubit auth;

  HomeCubit(this.auth) : super(HomeInitial()) {
    // ? if we set the lazy flag to false we don't need to build to activate the provider //
    getHomeData();
  }

  createEvent(Community community, String description, String time,
      DateTime date, String name, String location) async {
    final user = await StorageService().getUser();

    final event = EventModel(
      name: name,
      date: date,
      time: time,
      description: description,
      creator: user,
      location: location,
    );

    final communities =
        await StorageService().addEventToCommunity(community, event);
    final interests = await StorageService().getInterests();

    List<Community> filteredCommunities = communities.where((community) {
      return community.interests.any((type) => interests.contains(type));
    }).toList();

    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }

  createPost(Community community, String postContent) async {
    final user = await StorageService().getUser();

    final post = Post(user: user, post: postContent);

    final communities =
        await StorageService().addPostToCommunity(community, post);
    final interests = await StorageService().getInterests();

    List<Community> filteredCommunities = communities.where((community) {
      return community.interests.any((type) => interests.contains(type));
    }).toList();

    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }

  joinCommunity(Community community) async {
    final user = await StorageService().getUser();

    final communities = await StorageService().joinCommunity(community, user);
    final interests = await StorageService().getInterests();

    List<Community> filteredCommunities = communities.where((community) {
      return community.interests.any((type) => interests.contains(type));
    }).toList();

    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }

  getHomeData() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(seconds: 1));

    final userInterests = await StorageService().getInterests();
    final dummyCommunities = await StorageService().getDefaultCommunities();

    final filteredCommunities =
        filterCommunitiesByInterests(dummyCommunities, userInterests);
    late UserModel user;
    if (auth.state is AuthSuccess) {
      user = (auth.state as AuthSuccess).user;
    }
    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }

  createCommunity(
    String description,
    String name,
    String type,
    List<String> interestsList,
    BuildContext context,
  ) async {
    emit(CommunityCreationLoading());

    final user = await StorageService().getUser();

    final community = Community(
        events: [],
        creator: user,
        id: Random().nextInt(12),
        interests: interestsList,
        name: name,
        type: type,
        description: description,
        users: [user],
        posts: [],
        image: "");

    final updatedCommunities = await StorageService().addCommunity(community);
    final interests = await StorageService().getInterests();

    List<Community> filteredCommunities = updatedCommunities.where((community) {
      return community.interests.any((type) => interests.contains(type));
    }).toList();
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      context.read<BottomSheetNavigationCubit>().closeSheet();
    }
    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }

  addInterest(String interest) async {
    await StorageService().addInterest(interest);

    // Get updated data
    final userInterests = await StorageService().getInterests();
    final dummyCommunities = await StorageService().getDefaultCommunities();

    final filteredCommunities =
        filterCommunitiesByInterests(dummyCommunities, userInterests);

    final user = await StorageService().getUser();

    emit(HomeLoaded(communities: filteredCommunities, user: user));
  }
}
