import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String roomId;
  final String content;
  final String status;
  final String createdAt;
  final String updatedAt;
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.roomId,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? roomId,
    String? content,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'_id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'roomId': roomId});
    result.addAll({'content': content});
    result.addAll({'status': status});
    result.addAll({'createdAt': createdAt});
    result.addAll({'updatedAt': updatedAt});
  
    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      roomId: map['roomId'] ?? '',
      content: map['content'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, receiverId: $receiverId, roomId: $roomId, content: $content, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Message &&
      other.id == id &&
      other.senderId == senderId &&
      other.receiverId == receiverId &&
      other.roomId == roomId &&
      other.content == content &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      senderId.hashCode ^
      receiverId.hashCode ^
      roomId.hashCode ^
      content.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
