import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:zombieSurvival/game/components/bullet.dart';
import 'package:zombieSurvival/game/components/enemy.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';
import 'package:zombieSurvival/game/utils/statsCubit.dart';

class Player extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<GeoemtryFight>, CollisionCallbacks {
  late final SpawnComponent _bulletSpawner;
  final PlayerCubit playerCubit;
  late bool flag = false;
  bool playerIsDead = false;
  Vector2 moveDirection = Vector2.zero();
  bool isShooting = false;
  bool canShoot = false;
  bool wasShooting = false;
  bool wasMoving = false;
  Vector2 lastMoveDirection = Vector2.zero();
  final double moveSpeed = 160;

  Random rnd = Random();

  Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 200;

  Player({required this.playerCubit}) : super();
  @override
  FutureOr<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 32),
      ),
    );
    decorator.addLast(PaintDecorator.grayscale(opacity: 0.5));
    position = game.size / 2;
    anchor = Anchor.center;
    add(RectangleHitbox());
    _bulletSpawner = SpawnComponent(
      period: .6,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          direction: lastMoveDirection.normalized(),
          position: position + lastMoveDirection.normalized() * 20,
        );
      },
      autoStart: false,
    );
    game.add(_bulletSpawner);
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Reset moveDirection to zero before handling input
    moveDirection = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveDirection.x -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveDirection.x += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      moveDirection.y += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      moveDirection.y -= 1;
    }
    if (moveDirection.length > 0) {
      lastMoveDirection = moveDirection; // Update lastMoveDirection
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      isShooting = !isShooting; // Toggle shooting state
      if (isShooting && lastMoveDirection.length > 0) {
        startShooting();
      } else {
        stopShooting();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moveDirection.length > 0) {
      moveDirection.normalize();
      position += moveDirection * moveSpeed * dt;
    }
    if (playerCubit.state.isWinner) {
      clearScreen();
      gameRef.overlays.add('GameWon');
    }
    //clamping the Postion in the screen
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
    position.y = position.y.clamp(size.y / 2, game.size.y - size.y / 2);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      playerCubit.losePlayerLife();
      game.add(ParticleSystemComponent(
        particle: Particle.generate(
          count: 10,
          generator: (i) => AcceleratedParticle(
            acceleration: randomVector2(),
            child: CircleParticle(
              paint: Paint()..color = Colors.red,
            ),
          ),
        ),
        position: this.position,
      ));
      if (playerCubit.getPlayer() <= 0) {
        gameRef.overlays.add('GameOver'); // Show Game Over overlay
        clearScreen();
      }
      other.removeFromParent();
    }
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  void reset() {
    position = game.size / 2;

    playerCubit.reset();

    if (!game.children.contains(this)) {
      game.add(this);
    }
    game.add(game.enemySpawner);
    stopShooting();
    moveDirection = Vector2.zero();
  }

  void clearScreen() async {
    removeAllEnemies();
    gameRef.gameOver();
    stopShooting();
    this.removeFromParent();
  }

  void removeAllEnemies() {
    // Iterate over all components in the game and remove those that are instances of Enemy
    for (final component in game.children.toList()) {
      if (component is Enemy) {
        component.removeFromParent();
      }
    }
  }
}
