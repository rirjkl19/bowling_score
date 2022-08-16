// ignore_for_file: public_member_api_docs, sort_constructors_first
enum FrameTurn { waiting, first, second, third, ended }

enum FrameState { none, isStrike, isSpare }

class FrameModel {
  FrameModel({
    required this.id,
    this.first,
    this.second,
    this.third,
    this.frameState = FrameState.none,
    this.frameTurn = FrameTurn.waiting,
  });

  final int id;
  int? total;
  int? first;
  int? second;
  int? third;

  FrameState frameState;
  FrameTurn frameTurn;

  /// Total of [firstScore], [secondScore] and [thirdScore].
  int get totalTurnScore {
    return (first ?? 0) + (second ?? 0) + (third ?? 0);
  }

  int get remainingPins {
    return 10 - (first ?? 0) + (second ?? 0) + (third ?? 0);
  }

  @override
  String toString() => '\nFrameModel(id: $id, '
      'state: $frameState) '
      'turn: $frameTurn) ';
}
