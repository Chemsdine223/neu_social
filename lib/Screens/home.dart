import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Layouts/community_card_skeleton.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Logic/navigation_cubit.dart';
import 'package:neu_social/Screens/community_details.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/community_card.dart';
import 'package:neu_social/Widgets/creation_sheet.dart';
import 'package:neu_social/Widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: getProportionateScreenWidth(56),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return InkWell(onTap: () {
              Scaffold.of(context).openDrawer();
            }, child:
                BlocBuilder<BottomSheetNavigationCubit, BottomSheetStatus>(
              builder: (context, state) {
                return state == BottomSheetStatus.opened
                    ? Container()
                    : Image.asset('Img/menu.png');
              },
            ));
          }),
        ),
        actions: [
          Builder(builder: (context) {
            return BlocBuilder<BottomSheetNavigationCubit, BottomSheetStatus>(
              builder: (context, state) {
                // print(state);
                return IconButton(
                  onPressed: () {
                    state == BottomSheetStatus.closed
                        ? context.read<BottomSheetNavigationCubit>().openSheet()
                        : context
                            .read<BottomSheetNavigationCubit>()
                            .closeSheet();

                    if (state == BottomSheetStatus.closed) {
                      showBottomSheet(
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return const CreateCommunity();
                        },
                      );
                    } else if (state == BottomSheetStatus.opened) {
                      // Navigator.pop(context);
                      print(state);
                    }
                  },
                  icon: Icon(state == BottomSheetStatus.closed
                      ? Icons.add
                      : Icons.close),
                );
              },
            );
          }),
        ],
        centerTitle: true,
        title: Text(
          'Neu social',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.green.shade800,
              ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeError) {
            return const Text('An error occured');
          }
          if (state is HomeLoaded) {
            return ListView.builder(
              itemCount: state.communities.length,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(12),
                  vertical: getProportionateScreenHeight(12)),
              itemBuilder: (context, index) {
                final community = state.communities[index];
                return CommunityCard(
                  community: community,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetails(
                          community: community,
                        ),
                      )),
                );
              },
            );
          }
          return ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(12),
                vertical: getProportionateScreenHeight(12)),
            itemBuilder: (context, index) {
              return const CommunityCardSkeleton();
            },
          );
        },
      ),
    );
  }
}
