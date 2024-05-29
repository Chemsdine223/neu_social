import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Color color;
  final Widget? icon;
  final Text? label;
  final double radius;
  final double height;
  final double? width;
  final void Function()? onTap;

  const CustomButton({
    super.key,
    required this.color,
    this.icon,
    this.label,
    required this.radius,
    required this.height,
    this.width,
    this.onTap,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: Center(child: widget.label),
      ),
    );
  }
}
