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
}
