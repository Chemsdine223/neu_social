part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthUserCheck extends AuthState {}

final class Unauthorized extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
