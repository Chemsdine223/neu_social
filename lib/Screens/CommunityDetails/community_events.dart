import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';

import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Utils/DateTime/date_utilities.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Widgets/Dialogs/event_dialog.dart';

class CommunityEvents extends StatefulWidget {
  final Community community;
  const CommunityEvents({
    super.key,
    required this.community,
  });

  @override
  State<CommunityEvents> createState() => _CommunityEventsState();
}

class _CommunityEventsState extends State<CommunityEvents> {
  final controller = EventController();

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: controller,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            final currentCommunity = state.communities
                .where((c) => c.id == widget.community.id)
                .first;
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: MonthView(
                    borderColor: Theme.of(context).canvasColor,
                    useAvailableVerticalSpace: true,
                    startDay: WeekDays.monday,
                    pagePhysics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    hideDaysNotInMonth: true,
                    headerStringBuilder: (date, {secondaryDate}) {
                      // print(date.);
                      if (date.year != DateTime.now().year) {
                        return "${months[date.month - 1]} ${date.year}";
                      } else {
                        return months[date.month - 1];
                      }
                    },
                    weekDayBuilder: (day) {
                      return WeekDayTile(
                        backgroundColor: Colors.transparent,
                        dayIndex: day,
                        displayBorder: false,
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                      );
                    },
                    headerStyle: const HeaderStyle(
                        headerPadding: EdgeInsets.all(12),
                        rightIconVisible: false,
                        leftIconVisible: false,
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            )),
                    cellBuilder:
                        (date, event, isToday, isInMonth, hideDaysNotInMonth) {
                      final dates = currentCommunity.events
                          .where((element) => element.date == date)
                          .map((e) => e.date)
                          .toList();

                      if (!isInMonth) {
                        return Container(
                          color: Colors.transparent,
                        );
                      }

                      if (isToday) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              radius: 12,
                              child: Text(
                                date.day.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }
                      return dates.contains(date)
                          ? Stack(
                              children: [
                                Text(date.day.toString()),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor:
                                        date.isBefore(DateTime.now())
                                            ? Theme.of(context).disabledColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.transparent,
                              child: Text(date.day.toString()));
                    },
                    cellAspectRatio: .9,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentCommunity.events.length,
                  itemBuilder: (context, index) {
                    final event = currentCommunity.events[index];
                    return ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EventDialog(eventModel: event);
                          },
                        );
                      },
                      title: Text(event.name),
                      subtitle: Text(
                        '@${event.location}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Theme.of(context).disabledColor),
                      ),
                      trailing: Text(
                        formatDateTime(event.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              decoration: event.date.isBefore(DateTime.now())
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: event.date.isBefore(DateTime.now())
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                      ),
                    );
                  },
                )
                // MonthView(),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
