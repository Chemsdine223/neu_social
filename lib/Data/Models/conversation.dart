import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/user.dart';

class Conversation {
  final String id;
  final List<UserModel> users;
  final List<Message> messages;
  final String createdAt;
  final String updatedAt;
  Conversation({
    required this.id,
    required this.users,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? id,
    List<UserModel>? users,
    List<Message>? messages,
    String? createdAt,
    String? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      users: users ?? this.users,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});
    result.addAll({'createdAt': createdAt});
    result.addAll({'updatedAt': updatedAt});

    return result;
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['_id'] ?? '',
      users:
          List<UserModel>.from(map['users']?.map((x) => UserModel.fromMap(x))),
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Conversation(id: $id, users: $users, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation &&
        other.id == id &&
        listEquals(other.users, users) &&
        listEquals(other.messages, messages) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        users.hashCode ^
        messages.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
