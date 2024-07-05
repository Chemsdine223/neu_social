part of 'chat_cubit.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class Connected extends ChatState {
  final List<Conversation> conversations;

  Connected(this.conversations);
}

final class ChatLoading extends ChatState{}

final class Disconnected extends ChatState {
  final List<Conversation> conversations;

  Disconnected(this.conversations);
}
