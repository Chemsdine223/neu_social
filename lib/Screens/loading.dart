import 'package:flutter/material.dart';
import 'package:neu_social/Widgets/Misc/ovelay.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomOverlay(),
    );
  }
}
