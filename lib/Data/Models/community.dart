import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:neu_social/Data/Models/post.dart';
import 'package:neu_social/Data/Models/user.dart';

class Community {
  final int id;
  final String name;
  final List<String> type;
  final String description;
  final List<UserModel> users;
  final List<Post> posts;
  final String image;
  Community({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.users,
    required this.posts,
    required this.image,
  });

  Community copyWith({
    int? id,
    String? name,
    List<String>? type,
    String? description,
    List<UserModel>? users,
    List<Post>? posts,
    String? image,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
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
    result.addAll({'type': type});
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
      type: List<String>.from(map['type']),
      description: map['description'] ?? '',
      users: List<UserModel>.from(map['users']?.map((x) => UserModel.fromMap(x))),
      posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Community(id: $id, name: $name, type: $type, description: $description, users: $users, posts: $posts, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Community &&
      other.id == id &&
      other.name == name &&
      listEquals(other.type, type) &&
      other.description == description &&
      listEquals(other.users, users) &&
      listEquals(other.posts, posts) &&
      other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      description.hashCode ^
      users.hashCode ^
      posts.hashCode ^
      image.hashCode;
  }
}
