part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<UserModel> users;

  const SearchLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class SearchError extends SearchState {}
