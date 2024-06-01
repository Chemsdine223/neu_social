import 'dart:convert';

import 'package:neu_social/Data/Models/user.dart';

class EventModel {
  final String name;
  final DateTime date;
  final String time;
  final String description;
  final UserModel creator;
  final String location;
  EventModel({
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.creator,
    required this.location,
  });

  EventModel copyWith({
    String? name,
    DateTime? date,
    String? time,
    String? description,
    UserModel? creator,
    String? location,
  }) {
    return EventModel(
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      creator: creator ?? this.creator,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'time': time});
    result.addAll({'description': description});
    result.addAll({'creator': creator.toMap()});
    result.addAll({'location': location});

    return result;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      creator: UserModel.fromMap(map['creator']),
      location: map['location'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(name: $name, date: $date, time: $time, description: $description, creator: $creator, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.name == name &&
        other.date == date &&
        other.time == time &&
        other.description == description &&
        other.creator == creator &&
        other.location == location;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        date.hashCode ^
        time.hashCode ^
        description.hashCode ^
        creator.hashCode ^
        location.hashCode;
  }
}
