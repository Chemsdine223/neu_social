import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';

enum LogoutState { loading, initial, done, error }

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutState.initial);

  logout() async {
    emit(LogoutState.loading);
    await Future.delayed(const Duration(seconds: 1));
    await StorageService().clearStorage();
    
    emit(LogoutState.done);
  }
}
