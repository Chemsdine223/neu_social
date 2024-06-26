import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Data/Models/user.dart';

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

String formatDateTime(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
  final DateFormat formatter = DateFormat(format);

  return formatter.format(dateTime);
}

String formatTimeOfDay(TimeOfDay timeOfDay, {bool is24HourFormat = true}) {
  final now = DateTime.now();
  final dt =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

  final format = is24HourFormat ? 'HH:mm' : 'hh:mm a';
  final timeFormatter = DateFormat(format);

  return timeFormatter.format(dt);
}

Icon statusIcon(String status) {
  switch (status) {
    case 'sent':
      return const Icon(Icons.check_outlined);
    case 'unsent':
      return const Icon(Icons.pending);
    case 'received':
      return const Icon(Icons.done_all_rounded);
    case 'read':
      return Icon(
        Icons.done_all,
        color: Colors.blue.shade700,
      );

    default:
      return const Icon(Icons.pending);
  }
}
