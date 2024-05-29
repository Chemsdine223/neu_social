import 'package:flutter/material.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:readmore/readmore.dart';

class CommunityCard extends StatelessWidget {
  final void Function()? onTap;
  final Community community;

  const CommunityCard({
    super.key,
    this.onTap,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      community.type
                          .map((e) => e)
                          .toList()
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).disabledColor)
                      // .copyWith(fontWeight: FontWeight.bold),
                      ),
                ],
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
