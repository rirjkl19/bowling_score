import 'package:bowling_score/models/frame_model.dart';

class FinalFrameModel extends FrameModel {
  FinalFrameModel({
    required super.id,
    super.first,
    super.second,
    this.third,
    super.frameTurn,
    this.hasBonus = false,
  });

  int? third;
  bool hasBonus;

  @override
  int get remainingPins {
    switch (frameTurn) {
      case FrameTurn.first:
        return 10;
      case FrameTurn.second:
        if ((first ?? 0) < 10) return 10 - (first ?? 0);
        return 10;
      case FrameTurn.third:
        if ((first ?? 0) + (second ?? 0) == 10) return 10;
        if (totalTurnScore > 10) return 10;
        if ((second ?? 0) < 10) return 10 - (second ?? 0);
        return 10;
      default:
        return 0;
    }
  }

  @override
  int get totalTurnScore => (first ?? 0) + (second ?? 0) + (third ?? 0);

  @override
  String get firstScoreDisplay {
    switch (first) {
      case 0:
        return '-';
      case 10:
        return 'X';
      default:
        return '${first ?? ''}';
    }
  }

  @override
  String get secondScoreDisplay {
    switch (second) {
      case 0:
        return '-';
      case 10:
        return 'X';
      default:
        return '${second ?? ''}';
    }
  }

  String get thirdScoreDisplay {
    switch (third) {
      case 0:
        return '-';
      case 10:
        return 'X';
      default:
        return '${third ?? ''}';
    }
  }
}
