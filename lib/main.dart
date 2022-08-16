import 'package:bowling_score/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BowlingApp());
}

class BowlingApp extends StatelessWidget {
  const BowlingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainScreen());
  }
}
