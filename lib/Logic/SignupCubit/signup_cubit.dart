import 'package:bloc/bloc.dart';
import 'package:neu_social/Data/LocalStorage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Authentication { unauthenticated, authenticated, loading }

class SignupCubit extends Cubit<Authentication> {
  SignupCubit() : super(Authentication.unauthenticated) {
    getAuth();
  }

  void saveUser(
      String firstname, String lastname, DateTime dob, String email) async {
    emit(Authentication.loading);
    await Future.delayed(const Duration(seconds: 1));

    await StorageService().saveUser(firstname, lastname, dob, email);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    emit(Authentication.authenticated);
  }

  void getAuth() async {
    emit(Authentication.loading);
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.get('auth');
    if (auth == true) {
      emit(Authentication.authenticated);
    } else {
      emit(Authentication.unauthenticated);
    }
  }

  

}
