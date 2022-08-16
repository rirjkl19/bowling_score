import 'package:bowling_score/models/frame_model.dart';
import 'package:flutter/material.dart';

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    Key? key,
    required this.isSelected,
    required this.frameState,
    this.firstScore,
    this.secondScore,
    this.thirdScore,
    this.totalScore,
  }) : super(key: key);
  final bool isSelected;
  final FrameState frameState;
  final int? firstScore;
  final int? secondScore;
  final int? thirdScore;
  final int? totalScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        color: isSelected ? Colors.green.shade100 : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('$firstScore'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(border: Border.all()),
                child: Text('$secondScore'),
              ),
              if (thirdScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text('$thirdScore'),
                ),
            ],
          ),
          Text('$totalScore'),
        ],
      ),
    );
  }
}
