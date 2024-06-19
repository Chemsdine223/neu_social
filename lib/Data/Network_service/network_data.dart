import 'dart:convert';
import 'dart:developer';

import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:http/http.dart' as http;
import 'package:neu_social/Data/Network_service/network_auth.dart';

class NetworkData {
  Future<List<Conversation>> getConversations() async {
    await NetworkService.loadTokens();
    print(NetworkService.accessToken);
    final response = await http.get(
      Uri.parse(userConversations),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${NetworkService.accessToken}',
      },
    );
    // log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['conversations'] as List<dynamic>;
      final conversations =
          data.map((json) => Conversation.fromMap(json)).toList();

      // log(conversations[0].users[0].toString());

      return conversations;
    } else {
      return [];
    }
  }
}
