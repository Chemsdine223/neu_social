import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/user.dart';

class Conversation {
  final String id;
  final List<UserModel> users;
  final List<Message> messages;
  Conversation({
    required this.id,
    required this.users,
    required this.messages,
  });

  Conversation copyWith({
    String? id,
    List<UserModel>? users,
    List<Message>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      users: users ?? this.users,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': id});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['_id'] ?? '',
      users:
          List<UserModel>.from(map['users']?.map((x) => UserModel.fromMap(x))),
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));

  @override
  String toString() =>
      'Conversation(id: $id, users: $users, messages: $messages)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation &&
        other.id == id &&
        listEquals(other.users, users) &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode => id.hashCode ^ users.hashCode ^ messages.hashCode;
}
