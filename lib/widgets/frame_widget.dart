import 'package:bowling_score/models/final_frame_model.dart';
import 'package:bowling_score/models/frame_model.dart';
import 'package:bowling_score/models/regular_frame_model.dart';
import 'package:flutter/material.dart';

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    Key? key,
    required this.isSelected,
    required this.model,
  }) : super(key: key);

  final bool isSelected;
  final FrameModel model;

  @override
  Widget build(BuildContext context) {
    if (model.runtimeType == RegularFrameModel) {
      final frame = model as RegularFrameModel;
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
                  child: Text(frame.firstScoreDisplay),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(frame.secondScoreDisplay),
                ),
              ],
            ),
            Text('${model.total ?? ''}'),
          ],
        ),
      );
    } else if (model.runtimeType == FinalFrameModel) {
      final frame = model as FinalFrameModel;
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
                  child: Text(frame.firstScoreDisplay),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(frame.secondScoreDisplay),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(frame.thirdScoreDisplay),
                ),
              ],
            ),
            Text('${model.total ?? ''}'),
          ],
        ),
      );
    } else {
      return const Text('Error Unhandled Frame');
    }
  }
}
