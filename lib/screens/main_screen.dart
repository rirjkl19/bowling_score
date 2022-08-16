import 'dart:math';

import 'package:bowling_score/logic/scoring.dart';
import 'package:bowling_score/widgets/frame_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Scoring scoring = Scoring();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bowling Scorer')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: scoring.frames
                .map((frame) => FrameWidget(
                      isSelected: frame.id == scoring.currentFrameId,
                      model: frame,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: randomroll,
                    child: const Text('Random Roll'),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      numpadRow([1, 2, 3]),
                      numpadRow([4, 5, 6]),
                      numpadRow([7, 8, 9]),
                    ],
                  ),

                  // MaterialButton(
                  //   color: Colors.yellow,
                  //   onPressed: indicatedRoll,
                  //   child: const Text('Indicated Roll'),
                  // ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.green,
                    onPressed: strikeRoll,
                    child: const Text('Strike Roll'),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: gutterRoll,
                    child: const Text('Gutter Roll'),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  MaterialButton(
                    color: Colors.amber,
                    onPressed: undoRoll,
                    child: const Text('Reverse Roll'),
                  ),
                  const SizedBox(height: 16),
                  MaterialButton(
                    color: Colors.redAccent,
                    onPressed: restart,
                    child: const Text('Restart'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget numpadRow(List<int> count) {
    return Row(
        children: count.map((e) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        width: 20,
        child: MaterialButton(
          color: Colors.grey,
          onPressed: scoring.curentFrameModel.remainingPins >= e
              ? () => indicatedRoll(e)
              : null,
          child: Text(e.toString()),
        ),
      );
    }).toList());
  }

  void restart() {
    setState(() {
      scoring.restart();
    });
  }

  void strikeRoll() {
    setState(() {
      scoring.roll(10);
    });
  }

  void indicatedRoll(int pin) {
    setState(() {
      scoring.roll(pin);
    });
  }

  void randomroll() {
    final knockedPin = Random().nextInt(scoring.curentFrameModel.remainingPins);
    setState(() {
      scoring.roll(knockedPin);
    });
  }

  void gutterRoll() {
    setState(() {
      scoring.roll(0);
    });
  }

  void undoRoll() {
    // TODO: Do a undo roll
    throw UnimplementedError('Undo roll is unimplemented yet');
  }
}
