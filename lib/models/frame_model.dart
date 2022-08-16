// ignore_for_file: public_member_api_docs, sort_constructors_first
enum FrameTurn { waiting, first, second, third, ended }

enum FrameState { none, isStrike, isSpare }

abstract class FrameModel {
  FrameModel({
    required this.id,
    this.first,
    this.second,
    this.frameState = FrameState.none,
    this.frameTurn = FrameTurn.waiting,
  });

  final int id;
  int? total;
  int? first;
  int? second;

  FrameState frameState;
  FrameTurn frameTurn;

  int get totalTurnScore;
  int get remainingPins;
}
