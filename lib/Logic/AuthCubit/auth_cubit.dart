import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    verifyUser();
  }

  verifyUser() async {
    emit(AuthUserCheck());
    try {
      final user = await NetworkService.verifyUser();
      emit(AuthSuccess(user));
    } catch (e) {
      emit(Unauthorized());
    }
  }

  void signup(
    String firstname,
    String lastname,
    String dob,
    String email,
    String password,
  ) async {
    emit(AuthLoading());

    try {
      final user = await NetworkService.register(
          firstname, lastname, email, dob, password);


      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await NetworkService.login(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
