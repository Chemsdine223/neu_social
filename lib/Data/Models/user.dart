import 'dart:convert';

class UserModel {
  final String firstname;
  final String lastname;
  final DateTime dob;
  final String email;

  UserModel(
      {required this.firstname,
      required this.lastname,
      required this.dob,
      required this.email});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'dob': dob.millisecondsSinceEpoch});
    result.addAll({'email': email});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob']),
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
