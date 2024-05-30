import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:neu_social/Data/Models/post.dart';
import 'package:neu_social/Data/Models/user.dart';

class Community {
  final int id;
  final String name;
  final List<String> interests;
  final String type;
  final UserModel creator;
  final String description;
  final List<UserModel> users;
  final List<Post> posts;
  final String image;
  Community({
    required this.id,
    required this.name,
    required this.interests,
    required this.type,
    required this.creator,
    required this.description,
    required this.users,
    required this.posts,
    required this.image,
  });

  Community copyWith({
    int? id,
    String? name,
    List<String>? interests,
    String? type,
    UserModel? creator,
    String? description,
    List<UserModel>? users,
    List<Post>? posts,
    String? image,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      interests: interests ?? this.interests,
      type: type ?? this.type,
      creator: creator ?? this.creator,
      description: description ?? this.description,
      users: users ?? this.users,
      posts: posts ?? this.posts,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'interests': interests});
    result.addAll({'type': type});
    result.addAll({'creator': creator.toMap()});
    result.addAll({'description': description});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'posts': posts.map((x) => x.toMap()).toList()});
    result.addAll({'image': image});

    return result;
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      interests: List<String>.from(map['interests']),
      type: map['type'] ?? '',
      creator: UserModel.fromMap(map['creator']),
      description: map['description'] ?? '',
      users:
          List<UserModel>.from(map['users']?.map((x) => UserModel.fromMap(x))),
      posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Community(id: $id, name: $name, interests: $interests, type: $type, creator: $creator, description: $description, users: $users, posts: $posts, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        listEquals(other.interests, interests) &&
        other.type == type &&
        other.creator == creator &&
        other.description == description &&
        listEquals(other.users, users) &&
        listEquals(other.posts, posts) &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        interests.hashCode ^
        type.hashCode ^
        creator.hashCode ^
        description.hashCode ^
        users.hashCode ^
        posts.hashCode ^
        image.hashCode;
  }
}
