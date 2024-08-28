import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame/game.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';
import 'package:zombieSurvival/game/utils/statsCubit.dart';
import 'package:zombieSurvival/game/overlays/gameOverOverlay.dart';
import 'package:zombieSurvival/game/overlays/gameWonOverlay.dart';
import 'package:zombieSurvival/game/overlays/gameStartOverlay.dart';

void main() {
  final playerCubit = PlayerCubit(3);

  runApp(
    BlocProvider(
      create: (_) => playerCubit,
      child: GameWidget(
        game: GeoemtryFight(playerCubit: playerCubit),
        overlayBuilderMap: {
          'StartGame': (context, game) =>
              StartGameOverlay(gameRef: game as GeoemtryFight),
          'GameOver': (context, game) => BlocProvider.value(
                value: playerCubit,
                child: GameOverOverlay(gameRef: game as GeoemtryFight),
              ),
          'GameWon': (context, game) => BlocProvider.value(
                value: playerCubit,
                child: GameWonOverlay(gameRef: game as GeoemtryFight),
              ),
        },
        initialActiveOverlays: const ['StartGame'],
      ),
    ),
  );
}
