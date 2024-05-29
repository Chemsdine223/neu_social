import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neu_social/Data/LocalStorage/storage_service.dart';
import 'package:neu_social/Data/Models/community.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    getHomeData();
  }

  getHomeData() async {
    final interests = await StorageService().getInterests();

    final dummyCommunities = await StorageService().getDefaultCommunities();

    List<Community> communities = dummyCommunities.where((community) {
      return community.type.any((type) => interests.contains(type));
    }).toList();

    emit(HomeLoaded(communities: communities));
  }

  createCommunity(Community community) async {
    final updatedCommunities = await StorageService().addCommunity(community);
    final interests = await StorageService().getInterests();

    List<Community> filteredCommunities = updatedCommunities.where((community) {
      return community.type.any((type) => interests.contains(type));
    }).toList();

    emit(HomeLoaded(communities: filteredCommunities));
  }
}
