import 'package:flutter/material.dart';
import 'package:neu_social/Utils/size_config.dart';

Icon statusIcon(String status) {
  final size = getProportionateScreenHeight(16);
  switch (status) {
    case 'sent':
      return Icon(
        Icons.check_outlined,
        size: size,
      );
    case 'unsent':
      return Icon(Icons.pending, size: size);
    case 'received':
      return Icon(Icons.done_all_rounded, size: size);
    case 'read':
      return Icon(Icons.done_all, color: Colors.blue.shade700, size: size);

    default:
      return Icon(Icons.pending, size: size);
  }
}