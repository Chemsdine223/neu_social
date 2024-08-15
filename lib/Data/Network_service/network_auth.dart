import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static String accessToken = '';
  static String refreshToken = '';
  static String id = '';

  static Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUser),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'email': email,
          'password': password,
        },
      ),
    );

    // print(response.statusCode);
    // print(response.body);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = UserModel.fromMap(data['user']);

      accessToken = data['access'];
      id = data['user']['_id'];

      await saveTokens();
      return user;
    } else {
      throw data['message'];
    }
  }

  static Future<UserModel> verifyUser() async {
    await loadTokens();

    final response = await http.get(
      Uri.parse(getUser),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final user = UserModel.fromMap(data['user']);

      accessToken = data['access'];
      id = data['user']['_id'];
      await saveTokens();
      return user;
    } else {
      throw data['error'];
    }
  }

  static Future<UserModel> register(
    String firstName,
    String lastName,
    String email,
    String dob,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(registerUser),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "password": password,
          "firstname": firstName,
          "lastname": lastName,
          "email": email,
          "dob": "2000-12-01",
        },
      ),
    );

    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = UserModel.fromMap(data);
      log('user $user');

      accessToken = data['access'];
      id = data['user']['id'];

      await saveTokens();

      return user;
    } else {
      throw 'An error occured';
    }
  }

  // static Future<String> refresh() async {
  //   final response = await http.post(
  //     Uri.parse(refreshUrl),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'refresh': refreshToken}),
  //   );
  //   final data = jsonDecode(response.body);
  //   accessToken = data['access'];
  //   await saveTokens();
  //   return accessToken;
  // }

  static Future<void> saveTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('id', id);
  }

  static Future<String> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token') ?? '';
    // refreshToken = prefs.getString('refresh_token') ?? '';
    id = prefs.getString('id') ?? '';

    return accessToken;
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('id');
  }

  static bool isAuthenticated() {
    if (accessToken.isNotEmpty && !JwtDecoder.isExpired(accessToken)) {
      return true;
    } else {
      return false;
    }
  }
}
