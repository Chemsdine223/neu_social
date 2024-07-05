import 'package:flutter/material.dart';

void scrollToBottom(ScrollController scroll, double? positionScroll) {
  scroll.jumpTo(
    positionScroll == null
        ? scroll.position.maxScrollExtent
        : scroll.position.maxScrollExtent + positionScroll,
  );
}

void smoothScrollToBottom(ScrollController scroll, double? positionScroll) {
  scroll.animateTo(
    positionScroll == null
        ? scroll.position.maxScrollExtent
        : scroll.position.maxScrollExtent + positionScroll,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOut,
  );
}

void smoothScrollToTop(ScrollController scroll) {
  scroll.animateTo(
    scroll.position.minScrollExtent,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOut,
  );
}
