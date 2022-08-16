import 'dart:math';

import 'package:bowling_score/models/frame_model.dart';
import 'package:bowling_score/widgets/frame_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final textController = TextEditingController();
  int currentFrameId = 0;
  int knockPin = 0;

  List<FrameModel> setFrames = List.from({
    FrameModel(id: 0, frameTurn: FrameTurn.first),
    FrameModel(id: 1),
    FrameModel(id: 2),
    FrameModel(id: 3),
    FrameModel(id: 4),
    FrameModel(id: 5),
    FrameModel(id: 6),
    FrameModel(id: 7),
    FrameModel(id: 8),
    FrameModel(id: 9),
  });

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('${setFrames.map((e) => e.toString())}');
    return Scaffold(
      appBar: AppBar(title: const Text('Bowling Scorer')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: setFrames
                .map((e) => FrameWidget(
                      isSelected: e.id == currentFrameId,
                      frameState: e.frameState,
                      firstScore: e.first,
                      secondScore: e.second,
                      thirdScore: e.third,
                      totalScore: e.total,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: textController,
                          maxLines: 1,
                          decoration: const InputDecoration(isDense: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: (val) {
                            knockPin = int.tryParse(val) ?? 0;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      MaterialButton(
                        color: Colors.yellow,
                        onPressed: indicatedRoll,
                        child: const Text('Indicated Roll'),
                      ),
                    ],
                  ),
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
                    onPressed: reverseRoll,
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

  void strikeRoll() {
    roll(10);
  }

  void indicatedRoll() {
    roll(knockPin);
  }

  void randomroll() {
    final knockPin = Random().nextInt(setFrames[currentFrameId].remainingPins);
    roll(knockPin);
  }

  void gutterRoll() {
    roll(0);
  }

  void reverseRoll() {
    setState(() {
      if (currentFrameId == 0) {
        setFrames[0] = FrameModel(id: 0, frameTurn: FrameTurn.first);
        return;
      }
      setFrames[currentFrameId] = FrameModel(id: currentFrameId);
      setFrames[currentFrameId - 1] = FrameModel(
          id: currentFrameId - 1,
          frameState: FrameState.none,
          frameTurn: FrameTurn.first);
      currentFrameId--;
    });
  }

  void restart() {
    setState(() {
      currentFrameId = 0;
      knockPin = 0;
      setFrames = List.from({
        FrameModel(id: 0, frameTurn: FrameTurn.first),
        FrameModel(id: 1),
        FrameModel(id: 2),
        FrameModel(id: 3),
        FrameModel(id: 4),
        FrameModel(id: 5),
        FrameModel(id: 6),
        FrameModel(id: 7),
        FrameModel(id: 8),
        FrameModel(id: 9),
      });
    });
  }

  void addGlobalScore(int score) {}

  void roll(int knockedPin) {
    setState(() {
      if (setFrames[currentFrameId].id < 9) {
        // regular frames
        switch (setFrames[currentFrameId].frameTurn) {
          case FrameTurn.waiting:
            throw UnimplementedError();
          case FrameTurn.first:
            if (knockedPin == 10) {
              // * Will do this if ROLL is strike
              setFrames[currentFrameId]
                ..second = knockedPin
                ..frameState = FrameState.isStrike
                ..frameTurn = FrameTurn.ended;

              handleDoubleStrikeFirstTurn();

              moveNextFrame();
            } else {
              // * Regular roll in first turn
              setFrames[currentFrameId]
                ..first = knockedPin
                ..frameTurn = FrameTurn.second;

              handleDoubleStrikeFirstTurn();
              handleSpareFirstTurn();
            }

            break;
          case FrameTurn.second:
            if (setFrames[currentFrameId].remainingPins == knockedPin) {
              // * Will do this if ROLL is spare
              setFrames[currentFrameId]
                ..second = knockedPin
                ..frameTurn = FrameTurn.ended
                ..frameState = FrameState.isSpare;
              handlePreviousSpareSecondTurn();
              moveNextFrame();
            } else {
              // * Regular roll in second turn
              setFrames[currentFrameId]
                ..second = knockedPin
                ..frameTurn = FrameTurn.ended;

              handleStrikeSecondTurn();
              addTotalSecondTurn();

              moveNextFrame();
            }

            break;
          case FrameTurn.third:
            throw UnimplementedError();
          case FrameTurn.ended:
            throw UnimplementedError();
        }
      } else {
        // TODO: Handle final frame
        throw UnimplementedError('Unhandled final frame');
      }
      textController.clear();
    });
  }

  /// Move the current frame into the next one.
  void moveNextFrame() {
    print('Moving to next turn');
    currentFrameId++; // NEXT FRAME
    setFrames[currentFrameId].frameTurn = FrameTurn.first;
  }

  void handleDoubleStrikeFirstTurn() {
    if (currentFrameId < 2) return;

    // If 2 previous frames is strike
    if (setFrames[currentFrameId - 2].frameState == FrameState.isStrike) {
      if (setFrames[currentFrameId - 1].frameState == FrameState.isStrike) {
        int total = setFrames[currentFrameId - 2].totalTurnScore +
            setFrames[currentFrameId - 1].totalTurnScore +
            setFrames[currentFrameId].totalTurnScore;
        if (currentFrameId > 2) {
          total += setFrames[currentFrameId - 3].total ?? 0;
        }
        setFrames[currentFrameId - 2].total = total;
      }
    }
  }

  void handleSpareFirstTurn() {
    if (setFrames[currentFrameId - 1].frameState == FrameState.isSpare) {
      final prevTotal = (setFrames[currentFrameId - 2].total ?? 0) +
          setFrames[currentFrameId - 1].totalTurnScore +
          (setFrames[currentFrameId].first ?? 0);
      setFrames[currentFrameId - 1].total = prevTotal;
    }
  }

  void handleStrikeSecondTurn() {
    if (currentFrameId < 2) return;
    if (setFrames[currentFrameId - 2].frameState == FrameState.isStrike) {
      if (setFrames[currentFrameId - 1].frameState == FrameState.isStrike) {
        int prevTotal = (setFrames[currentFrameId - 2].total ?? 0) +
            setFrames[currentFrameId - 1].totalTurnScore +
            setFrames[currentFrameId].totalTurnScore;

        // Set first previous frame's total
        setFrames[currentFrameId - 1].total = prevTotal;

        final curTotal = (setFrames[currentFrameId - 1].total ?? 0) +
            setFrames[currentFrameId].totalTurnScore;

        // Set current frame's total
        setFrames[currentFrameId].total = curTotal;
      }
    }
  }

  void addTotalSecondTurn() {
    final curTotal = (setFrames[currentFrameId - 1].total ?? 0) +
        setFrames[currentFrameId].totalTurnScore;
    // Set current frame's total
    setFrames[currentFrameId].total = curTotal;
  }

  void handlePreviousSpareSecondTurn() {
    if (currentFrameId < 2) return;
    if (setFrames[currentFrameId - 1].frameState == FrameState.isStrike) {
      int prevTotal = (setFrames[currentFrameId - 2].total ?? 0) +
          setFrames[currentFrameId - 1].totalTurnScore +
          setFrames[currentFrameId].totalTurnScore;

      setFrames[currentFrameId - 1].total = prevTotal;
    }
  }
}
