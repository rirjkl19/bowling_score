import 'package:bowling_score/logic/scoring.dart';
import 'package:bowling_score/widgets/frame_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Scoring scoring = Scoring();
  late final textController = TextEditingController();
  int knockPin = 0;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
                    onPressed: undoRoll,
                    child: const Text('Reverse Roll'),
                  ),
                  const SizedBox(height: 16),
                  MaterialButton(
                    color: Colors.redAccent,
                    onPressed: scoring.restart,
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
    setState(() {
      scoring.roll(10);
    });
  }

  void indicatedRoll() {
    setState(() {
      scoring.roll(knockPin);
    });
  }

  void randomroll() {
    // TODO: Do a random roll
    throw UnimplementedError('Random roll is unimplemented yet');
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
