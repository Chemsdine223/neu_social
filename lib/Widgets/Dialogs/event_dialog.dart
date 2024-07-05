import 'package:flutter/material.dart';

import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Utils/DateTime/date_utilities.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';

class EventDialog extends StatefulWidget {
  final EventModel eventModel;
  const EventDialog({
    super.key,
    required this.eventModel,
  });

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'))
      ],
      actionsPadding: const EdgeInsets.all(4),
      insetPadding: const EdgeInsets.all(12),
      title: Text(
        widget.eventModel.name,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      content: SizedBox(
        height: getProportionateScreenHeight(200),
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoTile(
                context,
                'Hosted by',
                '${widget.eventModel.creator.firstname} ${widget.eventModel.creator.lastname} ',
              ),
              SizedBox(height: getProportionateScreenHeight(6)),
              _infoTile(
                context,
                'Location',
                '${widget.eventModel.location} ',
              ),
              SizedBox(height: getProportionateScreenHeight(6)),
              _infoTile(
                context,
                'Date',
                formatDateTime(widget.eventModel.date),
              ),
              SizedBox(height: getProportionateScreenHeight(6)),
              _infoTile(
                context,
                'Time',
                widget.eventModel.time,
              ),
              SizedBox(height: getProportionateScreenHeight(6)),
              Text(
                widget.eventModel.description,
              ),
            ],
          ),
        ),
      ),
    );
  }

  RichText _infoTile(BuildContext context, String label, String text) {
    return RichText(
      text: TextSpan(
        text: '$label : ',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black,
            ),
        children: [
          TextSpan(
            text: text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
