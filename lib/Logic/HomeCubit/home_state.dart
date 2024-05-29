part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Community> communities;

  const HomeLoaded({
    required this.communities,
  });

  @override
  List<Object> get props => [communities];
}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {}
