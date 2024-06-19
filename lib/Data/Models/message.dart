import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String roomId;
  final String content;
  final String status;
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.roomId,
    required this.content,
    required this.status,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? roomId,
    String? content,
    String? status,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      roomId: roomId ?? this.roomId,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'roomId': roomId});
    result.addAll({'content': content});
    result.addAll({'status': status});

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
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, receiverId: $receiverId, roomId: $roomId, content: $content, status: $status)';
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
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        roomId.hashCode ^
        content.hashCode ^
        status.hashCode;
  }
}
