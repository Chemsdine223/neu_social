import 'package:flutter/material.dart';


import 'package:neu_social/Data/Models/community.dart';


class CommunityEvents extends StatelessWidget {
  final Community community;
  const CommunityEvents({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text('data'),
    );
  }
}
