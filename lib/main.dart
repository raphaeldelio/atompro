import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AtomSimulation.dart';

void main() {
  runApp(
      const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp()
      ),
  );
}

bool evaluateScreen() {
  final Size size = window.physicalSize;

  return size.height / window.devicePixelRatio < 500 ||
      size.width / window.devicePixelRatio < 450;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (evaluateScreen()) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    return const AtomSimulation();
  }
}