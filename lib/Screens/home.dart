import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:neu_social/Layouts/community_card_skeleton.dart';
import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Screens/CommunityDetails/community_details.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Cards/community_card.dart';
import 'package:neu_social/Widgets/BottomSheets/community_creation_sheet.dart';
import 'package:neu_social/Widgets/Misc/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketCubit, WebSocketState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => HomeCubit(),
          child: Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () async {
            // errorSnackBar(context, 'text');
            // final prefs = await SharedPreferences.getInstance();
            // prefs.clear();
            //   },
            // ),
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
                  }, child: BlocBuilder<BottomSheetNavigationCubit,
                      BottomSheetStatus>(
                    builder: (context, state) {
                      return state == BottomSheetStatus.opened
                          ? Container()
                          : Image.asset(
                              'Img/menu.png',
                              color: Theme.of(context).primaryColor,
                            );
                    },
                  ));
                }),
              ),
              actions: [
                Builder(builder: (context) {
                  return BlocBuilder<BottomSheetNavigationCubit,
                      BottomSheetStatus>(
                    builder: (context, state) {
                      // print(state);
                      return IconButton(
                        onPressed: () {
                          state == BottomSheetStatus.closed
                              ? context
                                  .read<BottomSheetNavigationCubit>()
                                  .openSheet()
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
              title: BlocBuilder<BottomSheetNavigationCubit, BottomSheetStatus>(
                builder: (context, state) {
                  return Text(
                    state == BottomSheetStatus.opened
                        ? 'Create community'
                        : 'Neu social',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.green.shade800,
                        ),
                  );
                },
              ),
            ),
            body: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final homeCubitt = BlocProvider.of<HomeCubit>(context);
                if (state is HomeError) {
                  return const Text('An error occured');
                }
                if (state is HomeLoaded) {
                  return RefreshIndicator(
                    onRefresh: () => context.read<HomeCubit>().getHomeData(),
                    child: state.communities.isEmpty
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                                textAlign: TextAlign.center,
                                'Your interests doesn\'t have a match go to add interests by opening the drawer !'),
                          ))
                        : ListView.builder(
                            itemCount: state.communities.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(12),
                                vertical: getProportionateScreenHeight(12)),
                            itemBuilder: (context, index) {
                              final community = state.communities[index];

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                    child: Builder(builder: (context) {
                                  return CommunityCard(
                                      community: community,
                                      onTap: () {
                                        community.type.toLowerCase() ==
                                                    'paid' ||
                                                !community.users
                                                        .contains(state.user) &&
                                                    community.type
                                                            .toLowerCase() ==
                                                        'private'
                                            ? errorSnackBar(context,
                                                'Sorry, this is a ${community.type} community !')
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider.value(
                                                    value: homeCubitt,
                                                    child: CommunityDetails(
                                                      community: community,
                                                    ),
                                                  ),
                                                ),
                                              );
                                      });
                                })),
                              );
                            },
                          ),
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
          ),
        );
      },
    );
  }
}
