import 'package:bowling_score/models/frame_model.dart';

class RegularFrameModel extends FrameModel {
  RegularFrameModel({
    required super.id,
    super.first,
    super.second,
    super.frameTurn,
    super.frameState,
  });

  @override
  int get totalTurnScore => (first ?? 0) + (second ?? 0);

  @override
  int get remainingPins => 10 - totalTurnScore;

  @override
  String get firstScoreDisplay {
    switch (frameState) {
      case FrameState.none:
        if ((first ?? 0) == 0) return '-';
        return '${first ?? ''}';
      case FrameState.isStrike:
        return '';
      case FrameState.isSpare:
        return '${first ?? ''}';
    }
  }

  @override
  String get secondScoreDisplay {
    switch (frameState) {
      case FrameState.none:
        if ((second ?? 0) == 0) return '-';
        return '${second ?? ''}';
      case FrameState.isStrike:
        return 'X';
      case FrameState.isSpare:
        return '/';
    }
  }
}
