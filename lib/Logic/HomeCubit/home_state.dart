part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Community> communities;
  final UserModel user;

  const HomeLoaded({
    required this.communities,
    required this.user,
  });

  @override
  List<Object> get props => [communities, user];
}

final class CommunityCreationLoading extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {}
