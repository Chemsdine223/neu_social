import 'package:flutter/material.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class CommunityCardSkeleton extends StatefulWidget {
  const CommunityCardSkeleton({super.key});

  @override
  State<CommunityCardSkeleton> createState() =>
      _CommunityCardSkeletonSkeletonState();
}

class _CommunityCardSkeletonSkeletonState extends State<CommunityCardSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SizedBox(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: MediaQuery.of(context).size.width,
          height: getProportionateScreenHeight(140),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
