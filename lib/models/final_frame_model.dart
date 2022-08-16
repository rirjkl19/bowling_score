import 'package:bowling_score/models/frame_model.dart';

class FinalFrameModel extends FrameModel {
  FinalFrameModel({
    required super.id,
    super.first,
    super.second,
    this.third,
    super.frameTurn,
    super.frameState,
  });

  int? third;

  @override
  int get remainingPins => 10;

  @override
  int get totalTurnScore => (first ?? 0) + (second ?? 0) + (third ?? 0);
}
