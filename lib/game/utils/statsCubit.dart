import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statsState.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final int initialLives;
  final int winningPoints = 20; // Define the number of points required to win
  PlayerCubit(this.initialLives)
      : super(PlayerState(lives: initialLives, points: 0));

  int getPlayer() => state.lives;
  int getPoints() => state.points;

  void losePlayerLife() =>
      emit(PlayerState(lives: state.lives - 1, points: state.points));

  void gainPlayer() =>
      emit(PlayerState(lives: state.lives + 1, points: state.points));

  void addPoint() {
    final newPoints = state.points + 1;
    emit(PlayerState(lives: state.lives, points: newPoints));

    if (newPoints >= winningPoints) {
      // Trigger win condition
      emit(PlayerState(lives: state.lives, points: newPoints, isWinner: true));
    }
  }

  void reset() {
    emit(PlayerState(lives: initialLives, points: 0));
  }
}
