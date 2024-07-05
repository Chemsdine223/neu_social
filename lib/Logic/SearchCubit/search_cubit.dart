import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_data.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  searchUsers(String query) async {
    emit(SearchLoading());
    try {
      final users = await NetworkData().searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError());
    }
  }
}
