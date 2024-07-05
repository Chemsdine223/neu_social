import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Utils/size_config.dart';

errorSnackBar(BuildContext context, String text) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(text),
      ),
    );
  }
}

successSnackBar(BuildContext context, String text) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          text,
        ),
      ),
    );
  }
}

EventModel? findEvent(Community c, DateTime date) {
  try {
    return c.events.firstWhere((event) => event.date == date);
  } catch (e) {
    return null;
  }
}

List<Community> findUserCommunities(List<Community> c, UserModel user) {
  try {
    return c.where((community) => community.creator == user).toList();
  } catch (e) {
    return [];
  }
}

List<Community> filterCommunitiesByInterests(
    List<Community> communities, List<String> userInterests) {
  return communities.where((community) {
    // Check if any of the community's interests match the user's interests
    return community.interests
        .any((interest) => userInterests.contains(interest));
  }).toList();
}

String generateRandomString(int length) {
  const charset = 'abcdef0123456789';
  Random random = Random();
  return List.generate(
      length, (index) => charset[random.nextInt(charset.length)]).join('');
}
