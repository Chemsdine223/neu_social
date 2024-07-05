
import 'package:flutter/material.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class UsersSkeleton extends StatelessWidget {
  const UsersSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).canvasColor,
      highlightColor: Theme.of(context).secondaryHeaderColor,
      enabled: true,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Container(
          color: Colors.white,
          height: getProportionateScreenHeight(18),
          width: getProportionateScreenWidth(70),
        ),
        subtitle: Row(
          children: [
            Container(
                width: getProportionateScreenWidth(80),
                constraints: BoxConstraints(
                  maxHeight: getProportionateScreenHeight(12),
                ),
                color: Colors.black,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(''),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}