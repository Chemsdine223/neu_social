import 'package:flutter/material.dart';

import 'package:neu_social/Data/Models/message.dart';
import 'package:neu_social/Data/Network_service/network_auth.dart';
import 'package:neu_social/Utils/helpers.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.senderId == NetworkService.id
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.75, // Adjusts max width
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: message.senderId == NetworkService.id
              ? Colors.green
              : Colors.blue.shade900,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textAlign: message.senderId == NetworkService.id
                  ? TextAlign.end
                  : TextAlign.start,
              message.content,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: message.senderId == NetworkService.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                message.senderId != NetworkService.id
                    ? Container()
                    : statusIcon(message.status),
                const SizedBox(width: 5),
                const Text(
                  'HH:mm',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
