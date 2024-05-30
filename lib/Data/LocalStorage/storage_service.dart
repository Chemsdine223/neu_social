import 'dart:developer';

import 'package:neu_social/Data/DummyData/dummy.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/post.dart';

import 'package:neu_social/Data/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {


  Future<List<Community>> addPostToCommunity(Community community, Post newPost) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? jsonList = prefs.getStringList('communityListKey');

  List<Community> communityList = [];
  if (jsonList != null) {
    communityList = jsonList.map((community) => Community.fromJson(community)).toList();
  }

  communityList = communityList.map((c) {
    if (c.id == community.id) {
      return c.copyWith(posts: [newPost, ...c.posts]);
    }
    return c;
  }).toList();

  // Serialize the updated community list and save it back to SharedPreferences
  final List<String> updatedJsonList = communityList.map((community) => community.toJson()).toList();
  await prefs.setStringList('communityListKey', updatedJsonList);

  // Return the updated community list
  return communityList;
}


  Future<List<Community>> joinCommunity(Community community, UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? jsonList = prefs.getStringList('communityListKey');

  List<Community> communityList = [];
  if (jsonList != null) {
    communityList = jsonList.map((community) => Community.fromJson(community)).toList();
  }

  communityList = communityList.map((c) {
    if (c.id == community.id) {
      return c.copyWith(users: [user, ...c.users]);
    }
    return c;
  }).toList();

  // Serialize the updated community list and save it back to SharedPreferences
  final List<String> updatedJsonList = communityList.map((community) => community.toJson()).toList();
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

    return UserModel(
      firstname: firstname ?? '',
      lastname: lastname ?? '',
      dob: DateTime.parse(dob ?? ""),
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

    return prefs.getStringList('interests') ?? [];
  }

  Future<void> saveInterests(List<String> interests) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('interests', interests);
  }
}
