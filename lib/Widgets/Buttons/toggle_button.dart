import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatefulWidget {
  final bool initialPostsState;
  final ValueChanged<bool> onToggle;

  const ToggleButtonsWidget({
    super.key,
    required this.initialPostsState,
    required this.onToggle,
  });

  @override
  State<ToggleButtonsWidget> createState() => _ToggleButtonsWidgetState();
}

class _ToggleButtonsWidgetState extends State<ToggleButtonsWidget> {
  late bool posts;

  @override
  void initState() {
    super.initState();
    posts = widget.initialPostsState;
  }

  void _toggle(bool isPosts) {
    setState(() {
      posts = isPosts;
    });
    widget.onToggle(posts);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _toggle(true),
            child: Container(
              decoration: BoxDecoration(
                color: posts
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Posts',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        // color: posts ? Colors.white : Colors.black,
                        fontWeight: posts ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _toggle(false),
            child: Container(
              decoration: BoxDecoration(
                color: !posts
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Events',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        // color: !posts ? Colors.white : Colors.black,
                        fontWeight:
                            !posts ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
