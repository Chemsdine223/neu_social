import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Utils/size_config.dart';

class CommunityCard extends StatelessWidget {
  final void Function()? onTap;
  final Community community;
  final bool clickable;

  const CommunityCard({
    super.key,
    this.onTap,
    required this.community,
    required this.clickable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickable == false ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(1, 1),
              )
            ]),
        margin: const EdgeInsets.only(bottom: 8),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    community.image == ''
                        ? 'Img/social-media.png'
                        : community.image,
                    height: getProportionateScreenHeight(70),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    community.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Builder(
                    builder: (context) {
                      switch (community.type.toLowerCase()) {
                        case 'private':
                          return Image.asset('Img/lock.png',
                              height: getProportionateScreenHeight(16));
                        case 'paid':
                          return Image.asset('Img/dollar-symbol.png',
                              height: getProportionateScreenHeight(16));
                        default:
                          return Image.asset('Img/public-relation.png',
                              height: getProportionateScreenHeight(16));
                      }
                    },
                  )
                ],
              ),
              ReadMoreText(
                community.interests
                    .map((e) => e)
                    .toList()
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", ""),
                trimLines: 1,
                moreStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                lessStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                trimMode: TrimMode.Line,
                textAlign: TextAlign.start,
              ),
              ReadMoreText(
                preDataText: "",
                postDataText: "",
                community.description,

                // trimExpandedText: "",

                trimLines: 2,
                moreStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                lessStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                trimMode: TrimMode.Line,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
