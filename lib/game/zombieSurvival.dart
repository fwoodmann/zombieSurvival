import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:zombieSurvival/game/components/enemy.dart';
import 'package:zombieSurvival/game/overlays/statsDisplayComponent.dart';
import 'package:zombieSurvival/game/components/player.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zombieSurvival/game/utils/statsCubit.dart';

class GeoemtryFight extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  late PlayerCubit playerCubit;
  bool playerIsDead = false;
  late SpawnComponent enemySpawner;

  GeoemtryFight({required this.playerCubit});

  @override
  FutureOr<void> onLoad() async {
    // Initial setup without starting the game
    playerCubit = PlayerCubit(3); // Initialize a Player with 3 lives
    add(PlayerDisplayComponent(playerCubit: playerCubit));

    player = Player(playerCubit: playerCubit)
      ..position = size / 2
      ..width = 96
      ..height = 96
      ..anchor = Anchor.center;
    FlameAudio.bgm.initialize();
  }

  void startGame() {
    // Add player and spawner when game starts
    add(player);
    enemySpawner = SpawnComponent(
        factory: (index) {
          return Enemy(playerCubit);
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, size.y),
        within: false);

    add(enemySpawner);
    startBgmMusic();
    resumeEngine();
  }

  void startBgmMusic() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('bg.mp3', volume: 0.5);
  }

  @override
  Color backgroundColor() {
    PaintDecorator.grayscale();
    return Colors.amber.shade100;
  }

  void gameOver() {
    // Remove the enemy spawner when the game is over
    remove(enemySpawner);
  }

  void resetGame() {
    player.reset();
  }
}
