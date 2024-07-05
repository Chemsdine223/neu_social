import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';

enum LogoutState { loading, initial, done, error }

class LogoutCubit extends Cubit<LogoutState> {
  ChatCubit chatCubit;
  LogoutCubit(
    this.chatCubit,
  ) : super(LogoutState.initial);

  logout() async {
    emit(LogoutState.loading);
    await Future.delayed(const Duration(seconds: 1));

    chatCubit.disconnectSocket();

    await StorageService().clearStorage();

    emit(LogoutState.done);
  }
}
