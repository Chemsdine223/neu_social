import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Authentication { unauthenticated, authenticated, loading }

class SignupCubit extends Cubit<Authentication> {
  SignupCubit() : super(Authentication.unauthenticated) {
    getAuth();
  }

  

  void getAuth() async {
    emit(Authentication.loading);
    await Future.delayed(const Duration(seconds: 1));

    final auth = await StorageService().authenticityCheck();
    log(auth.toString());
    // final prefs = await SharedPreferences.getInstance();
    // final auth = prefs.get('auth');
    if (auth == true) {
      emit(Authentication.authenticated);
    } else {
      emit(Authentication.unauthenticated);
    }
  }
}
