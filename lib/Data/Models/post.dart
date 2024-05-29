import 'dart:convert';

import 'package:neu_social/Data/Models/user.dart';

class Post {
  final UserModel user;
  final String post;
  Post({
    required this.user,
    required this.post,
  });

  Post copyWith({
    UserModel? user,
    String? post,
  }) {
    return Post(
      user: user ?? this.user,
      post: post ?? this.post,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'user': user.toMap()});
    result.addAll({'post': post});
  
    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      user: UserModel.fromMap(map['user']),
      post: map['post'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() => 'Post(user: $user, post: $post)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Post &&
      other.user == user &&
      other.post == post;
  }

  @override
  int get hashCode => user.hashCode ^ post.hashCode;
}
