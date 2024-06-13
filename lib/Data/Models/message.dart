import 'dart:convert';

class Message {
  final String id;
  final String content;
  final String status;
  Message({
    required this.id,
    required this.content,
    required this.status,
  });

  Message copyWith({
    String? id,
    String? content,
    String? status,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'_id': id});
    result.addAll({'content': content});
    result.addAll({'status': status});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? '',
      content: map['content'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() => 'Message(id: $id, content: $content, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.content == content &&
        other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ status.hashCode;
}
