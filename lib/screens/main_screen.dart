import 'dart:math';

import 'package:bowling_score/logic/scoring.dart';
import 'package:bowling_score/models/final_frame_model.dart';
import 'package:bowling_score/widgets/frame_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Scoring scoring = Scoring();
  bool isDialogShown = false;

  @override
  Widget build(BuildContext context) {
    if (scoring.gameEnded && !isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Game ended'),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      restart();
                      isDialogShown = false;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Restart game'),
                  ),
                ],
              );
            });
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bowling Scorer')),
      body: Container(
        alignment: Alignment.center,
        color: Colors.grey.shade300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Frame: ${scoring.currentFrameId + 1}'),
              Text('Current Turn:'
                  ' ${describeEnum(scoring.currentFrameModel.frameTurn)}'),
              Text('Remaining pin: ${scoring.currentFrameModel.remainingPins}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.green,
                        onPressed: scoring.currentFrameModel.remainingPins == 10
                            ? strikeRoll
                            : null,
                        child: const Text('Strike Roll'),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.red,
                        onPressed: gutterRoll,
                        child: const Text('Gutter Roll'),
                      ),
                      const SizedBox(height: 20),
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
        ),
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
          onPressed: scoring.currentFrameModel.remainingPins >= e
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
    late final int knockedPin;
    if (scoring.currentFrameModel.runtimeType == FinalFrameModel) {
      knockedPin = Random().nextInt(10);
    } else {
      knockedPin = Random().nextInt(scoring.currentFrameModel.remainingPins);
    }
    setState(() {
      scoring.roll(knockedPin);
    });
  }

  void gutterRoll() {
    setState(() {
      scoring.roll(0);
    });
  }
}
