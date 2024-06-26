import 'dart:convert';
import 'dart:developer';

import 'package:neu_social/Data/DummyData/dummy.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/conversation.dart';
import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Models/post.dart';

import 'package:neu_social/Data/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedMessages =
        jsonEncode(messages.map((message) => message.toMap()).toList());
    await prefs.setString('messages', encodedMessages);
  }

  static Future<List<Conversation>> loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedMessages = prefs.getString('messages');
    if (encodedMessages != null) {
      final List<dynamic> decodedMessages = jsonDecode(encodedMessages);
      return decodedMessages
          .map((message) => Conversation.fromMap(message))
          .toList();
    }
    return [];
  }

  Future<List<Community>> addPostToCommunity(
      Community community, Post newPost) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('communityListKey');

    List<Community> communityList = [];
    if (jsonList != null) {
      communityList =
          jsonList.map((community) => Community.fromJson(community)).toList();
    }

    communityList = communityList.map((c) {
      if (c.id == community.id) {
        return c.copyWith(posts: [newPost, ...c.posts]);
      }
      return c;
    }).toList();

    // Serialize the updated community list and save it back to SharedPreferences
    final List<String> updatedJsonList =
        communityList.map((community) => community.toJson()).toList();
    await prefs.setStringList('communityListKey', updatedJsonList);

    // Return the updated community list
    return communityList;
  }

  Future<List<Community>> addEventToCommunity(
      Community community, EventModel newEvent) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('communityListKey');

    List<Community> communityList = [];
    if (jsonList != null) {
      communityList =
          jsonList.map((community) => Community.fromJson(community)).toList();
    }

    communityList = communityList.map((c) {
      if (c.id == community.id) {
        return c.copyWith(events: [newEvent, ...c.events]);
      }
      return c;
    }).toList();

    // Serialize the updated community list and save it back to SharedPreferences
    final List<String> updatedJsonList =
        communityList.map((community) => community.toJson()).toList();
    await prefs.setStringList('communityListKey', updatedJsonList);

    // Return the updated community list
    return communityList;
  }

  Future<List<Community>> joinCommunity(
      Community community, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('communityListKey');

    List<Community> communityList = [];
    if (jsonList != null) {
      communityList =
          jsonList.map((community) => Community.fromJson(community)).toList();
    }

    communityList = communityList.map((c) {
      if (c.id == community.id) {
        return c.copyWith(users: [user, ...c.users]);
      }
      return c;
    }).toList();

    // Serialize the updated community list and save it back to SharedPreferences
    final List<String> updatedJsonList =
        communityList.map((community) => community.toJson()).toList();
    await prefs.setStringList('communityListKey', updatedJsonList);

    // Return the updated community list
    return communityList;
  }

  Future<List<Community>> addCommunity(Community newCommunity) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('communityListKey');

    List<Community> communityList = [];
    if (jsonList != null) {
      communityList =
          jsonList.map((community) => Community.fromJson(community)).toList();
    }

    communityList.insert(0, newCommunity);

    final List<String> updatedJsonList =
        communityList.map((community) => community.toJson()).toList();
    await prefs.setStringList('communityListKey', updatedJsonList);

    return communityList;
  }

  Future<void> setDefaultCommunity() async {
    log('SetDefault');
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        dummyCommunities.map((community) => community.toJson()).toList();

    await prefs.setStringList('communityListKey', jsonList);
  }

  Future<List<Community>> getDefaultCommunities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('communityListKey');

    // log(jsonList.toString());

    if (jsonList != null) {
      return jsonList.map((jsonStr) => Community.fromJson(jsonStr)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveUser(
      String firstname, String lastname, DateTime dob, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstname', firstname);
    prefs.setString('lastname', lastname);
    prefs.setString('dob', dob.toString());
    prefs.setString('email', email);
  }

  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final firstname = prefs.getString('firstname');
    final lastname = prefs.getString('lastname');
    final dob = prefs.getString('dob');
    final email = prefs.getString('email');
    final id = prefs.getString('id');

    return UserModel(
      id: id ?? '',
      firstname: firstname ?? '',
      lastname: lastname ?? '',
      dob: dob ?? "",
      email: email ?? '',
    );
  }

  Future<dynamic> authenticityCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.get('auth');
    return auth ?? false;
  }

  Future<List<String>> getInterests() async {
    final prefs = await SharedPreferences.getInstance();

    final interr = prefs.getStringList('interests') ?? [];
    log(interr.toString());

    return prefs.getStringList('interests') ?? [];
  }

  Future<void> saveInterests(List<String> interests) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('interests', interests);
  }

  Future<void> addInterest(String interest) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the current list of interests
    List<String> currentInterests = prefs.getStringList('interests') ?? [];

    // Add the new interest if it does not already exist
    if (!currentInterests.contains(interest)) {
      currentInterests.add(interest);
    }

    // Save the updated list
    await prefs.setStringList('interests', currentInterests);
  }

  Future<void> removeInterest(String interest) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the current list of interests
    List<String> currentInterests = prefs.getStringList('interests') ?? [];

    // Add the new interest if it does not already exist
    if (currentInterests.contains(interest)) {
      currentInterests.remove(interest);
    }

    // Save the updated list
    await prefs.setStringList('interests', currentInterests);
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await setDefaultCommunity();
  }
}
