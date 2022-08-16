import 'package:bowling_score/models/final_frame_model.dart';
import 'package:bowling_score/models/frame_model.dart';
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
                child: Text(firstScoreDisplay),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(secondScoreDisplay),
              ),
              if (model.runtimeType == FinalFrameModel)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(thirdScoreDisplay),
                ),
            ],
          ),
          Text('${model.total ?? ''}'),
        ],
      ),
    );
  }

  String get firstScoreDisplay {
    if (model.runtimeType == FinalFrameModel) {
      switch (model.first) {
        case 0:
          return '-';
        case 10:
          return 'X';
        default:
          return '${model.first ?? ''}';
      }
    } else {
      switch (model.frameState) {
        case FrameState.none:
          return '${model.first ?? ''}';
        case FrameState.isStrike:
          return '';
        case FrameState.isSpare:
          return '${model.first ?? ''}';
      }
    }
  }

  String get secondScoreDisplay {
    if (model.runtimeType == FinalFrameModel) {
      switch (model.second) {
        case 0:
          return '-';
        case 10:
          return 'X';
        default:
          return '${model.second ?? ''}';
      }
    } else {
      switch (model.frameState) {
        case FrameState.none:
          return '${model.second ?? ''}';
        case FrameState.isStrike:
          return 'X';
        case FrameState.isSpare:
          return '/';
      }
    }
  }

  String get thirdScoreDisplay {
    if (model.runtimeType == FinalFrameModel) {
      final frame = model as FinalFrameModel;
      switch (frame.third) {
        case 0:
          return '-';
        case 10:
          return 'X';
        default:
          return '${frame.third ?? ''}';
      }
    } else {
      switch (model.frameState) {
        case FrameState.none:
          return '${model.second ?? ''}';
        case FrameState.isStrike:
          return 'X';
        case FrameState.isSpare:
          return '/';
      }
    }
  }
}
