import 'dart:convert';

import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:http/http.dart' as http;
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';

class NetworkData {
  Future<List<Conversation>> getConversations() async {
    await NetworkService.loadTokens();
    final response = await http.get(
      Uri.parse(userConversations),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${NetworkService.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['conversations'] as List<dynamic>;
      final conversations =
          data.map((json) => Conversation.fromMap(json)).toList();
      return conversations;
    } else {
      return [];
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    await NetworkService.loadTokens();
    final response = await http.get(
      Uri.parse('$searchUsersUrl?search=$query'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['users'] as List<dynamic>;
      final users = data.map((json) => UserModel.fromMap(json)).toList();

      return users;
    } else {
      return [];
    }
  }
}
