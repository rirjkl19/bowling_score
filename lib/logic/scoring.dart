import 'package:bowling_score/models/final_frame_model.dart';
import 'package:bowling_score/models/frame_model.dart';
import 'package:bowling_score/models/regular_frame_model.dart';

class Scoring {
  Scoring() : super() {
    restart();
  }
  static const frameCount = 10;

  List<FrameModel> frames = [];
  int currentFrameId = 0;
  bool gameEnded = false;

  FrameModel get currentFrameModel => frames[currentFrameId];

  /// Restart the current [frames] to initial scoring.
  void restart() {
    gameEnded = false;
    currentFrameId = 0;
    frames = List.generate(frameCount, (index) {
      if (index == 0) {
        return RegularFrameModel(id: index, frameTurn: FrameTurn.first);
      } else if (index < frameCount - 1) {
        return RegularFrameModel(id: index);
      } else {
        return FinalFrameModel(id: index);
      }
    });
  }

  void roll(int knockedPin) {
    if (frames[currentFrameId].runtimeType == RegularFrameModel) {
      switch (frames[currentFrameId].frameTurn) {
        case FrameTurn.waiting:
          throw Exception(
              'Current frame is waiting (should be atleast in turn)');

        case FrameTurn.first:
          if (knockedPin == 10) {
            // * Strike Roll
            frames[currentFrameId]
              ..second = knockedPin
              ..frameState = FrameState.isStrike;

            _handleDoubleStrikeFirstTurn();
            _handleSpare();
            _moveNextFrame();
          } else {
            // * Regular roll

            frames[currentFrameId]
              ..first = knockedPin
              ..frameTurn = FrameTurn.second;

            _handleDoubleStrikeFirstTurn();
            _handleSpare();
          }

          break;
        case FrameTurn.second:
          if (frames[currentFrameId].remainingPins == knockedPin) {
            // * Spare Roll
            frames[currentFrameId]
              ..second = knockedPin
              ..frameState = FrameState.isSpare;

            _handleOneStrike();
            _moveNextFrame();
          } else {
            // * Regular roll

            frames[currentFrameId].second = knockedPin;

            _handleDoubleStrikeSecondTurn();
            _handleOneStrike();
            _handleAddTotalSecondTurn();

            _moveNextFrame();
          }

          break;
        case FrameTurn.third:
          throw UnimplementedError('Regular frames doesn\t have a third round');
      }
    } else if (frames[currentFrameId].runtimeType == FinalFrameModel) {
      switch (frames[currentFrameId].frameTurn) {
        case FrameTurn.waiting:
          throw Exception(
              'Current frame is waiting (should be atleast in turn)');
        case FrameTurn.first:
          if (knockedPin == 10) {
            // * Strike Roll
            frames[currentFrameId] as FinalFrameModel
              ..first = knockedPin
              ..hasBonus = true
              ..frameTurn = FrameTurn.second;

            _handleDoubleStrikeFirstTurn();
            _handleSpare();

            break;
          }

          // * Regular roll
          frames[currentFrameId]
            ..first = knockedPin
            ..frameTurn = FrameTurn.second;

          break;
        case FrameTurn.second:
          if (knockedPin == 10) {
            // * Strike Roll
            frames[currentFrameId] as FinalFrameModel
              ..second = knockedPin
              ..hasBonus = true
              ..frameTurn = FrameTurn.third;

            _handleOneStrike();

            break;
          }

          if (frames[currentFrameId].remainingPins == knockedPin) {
            // * Spare roll
            frames[currentFrameId] as FinalFrameModel
              ..second = knockedPin
              ..hasBonus = true
              ..frameTurn = FrameTurn.third;

            break;
          } else {
            // * Regular roll
            frames[currentFrameId]
              ..second = knockedPin
              ..frameTurn = FrameTurn.third;
          }

          gameEnded = !(currentFrameModel as FinalFrameModel).hasBonus;

          break;
        case FrameTurn.third:
          if (knockedPin == 10) {
            // * Strike Roll
            (frames[currentFrameId] as FinalFrameModel).third = knockedPin;
            _handleAddTotalSecondTurn();
          }

          // * Regular roll
          (frames[currentFrameId] as FinalFrameModel).third = knockedPin;
          _handleAddTotalSecondTurn();
          gameEnded = true;
          break;
      }
    } else {
      throw Exception('Invalid FrameModel');
    }
  }

  /// Handler if the current frame has 2 previous frame that is [FrameState.isStrike].
  /// - Will add existing total score with current score to the 2nd previous frame.
  void _handleDoubleStrikeFirstTurn() {
    if (currentFrameId < 2) return;
    // If 2 previous frames is strike
    if (frames[currentFrameId - 2].frameState == FrameState.isStrike) {
      if (frames[currentFrameId - 1].frameState == FrameState.isStrike) {
        int total = frames[currentFrameId - 2].totalTurnScore +
            frames[currentFrameId - 1].totalTurnScore +
            frames[currentFrameId].totalTurnScore;
        if (currentFrameId > 2) {
          total += frames[currentFrameId - 3].total ?? 0;
        }

        frames[currentFrameId - 2].total = total;
      }
    }
  }

  /// Handler if the current frame has 2 previous frame that is [FrameState.isStrike].
  void _handleDoubleStrikeSecondTurn() {
    if (currentFrameId < 2) return;
    if (frames[currentFrameId - 2].frameState == FrameState.isStrike) {
      if (frames[currentFrameId - 1].frameState == FrameState.isStrike) {
        int prevTotal = (frames[currentFrameId - 2].total ?? 0) +
            frames[currentFrameId - 1].totalTurnScore +
            frames[currentFrameId].totalTurnScore;

        // Set first previous frame's total
        frames[currentFrameId - 1].total = prevTotal;

        final curTotal = (frames[currentFrameId - 1].total ?? 0) +
            frames[currentFrameId].totalTurnScore;

        // Set current frame's total
        frames[currentFrameId].total = curTotal;
      }
    }
  }

  /// Handler if the current frame has 1 previous frame that is [FrameState.isSpare].
  /// - Will add previous total score with current score to the previous frame.
  void _handleSpare() {
    if (currentFrameId < 2) return;
    if (frames[currentFrameId - 1].frameState == FrameState.isSpare) {
      final prevTotal = (frames[currentFrameId - 2].total ?? 0) +
          frames[currentFrameId - 1].totalTurnScore +
          (frames[currentFrameId].totalTurnScore);

      frames[currentFrameId - 1].total = prevTotal;
    }
  }

  /// Handler if the current frame has 1 previous frame that is [FrameState.isStrike].
  void _handleOneStrike() {
    if (currentFrameId < 2) return;
    if (frames[currentFrameId - 1].frameState == FrameState.isStrike) {
      int prevTotal = (frames[currentFrameId - 2].total ?? 0) +
          frames[currentFrameId - 1].totalTurnScore +
          frames[currentFrameId].totalTurnScore;

      frames[currentFrameId - 1].total = prevTotal;
    }
  }

  /// Handler of frame's total score when the current frame's 2nd turn is a regular roll.
  void _handleAddTotalSecondTurn() {
    if (currentFrameId == 0) {
      final curTotal = frames[currentFrameId].totalTurnScore;
      // Set current frame's total
      frames[currentFrameId].total = curTotal;
    } else {
      final curTotal = (frames[currentFrameId - 1].total ?? 0) +
          frames[currentFrameId].totalTurnScore;
      // Set current frame's total
      frames[currentFrameId].total = curTotal;
    }
  }

  /// Move the current frame into the next one.
  void _moveNextFrame() {
    currentFrameId++;
    frames[currentFrameId].frameTurn = FrameTurn.first;
  }
}
