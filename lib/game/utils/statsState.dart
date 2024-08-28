part of 'statsCubit.dart';

class PlayerState extends Equatable {
  final int lives;
  final int points;
  final bool isWinner;

  PlayerState(
      {required this.lives, required this.points, this.isWinner = false});

  @override
  List<Object> get props => [lives, points, isWinner];
}
