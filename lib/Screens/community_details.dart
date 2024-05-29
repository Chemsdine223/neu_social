import 'package:flutter/material.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Utils/size_config.dart';

class CommunityDetails extends StatefulWidget {
  final Community community;
  const CommunityDetails({
    super.key,
    required this.community,
  });

  @override
  State<CommunityDetails> createState() => _CommunityDetailsState();
}

class _CommunityDetailsState extends State<CommunityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: getProportionateScreenWidth(56),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            );
          }),
        ),
        title: Text(widget.community.name),
      ),
      body: const Column(),
    );
  }
}
