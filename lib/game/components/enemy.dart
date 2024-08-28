import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:zombieSurvival/game/components/bullet.dart';
import 'package:zombieSurvival/game/components/explosion.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';
import 'package:zombieSurvival/game/utils/statsCubit.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<GeoemtryFight>, CollisionCallbacks {
  final PlayerCubit playerCubit; // The Cubit instance
  Enemy(
    this.playerCubit, {
    super.position,
  }) : super(size: Vector2.all(enemySize), anchor: Anchor.center) {}
  static const enemySize = 64.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(32),
      ),
    );
    add(RectangleHitbox());
    applyPulsatingEffect();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    //enemy move towards player
    Vector2 dir = new Vector2(0, 0);
    dir.x = game.player.position.x - position.x;
    dir.y = game.player.position.y - position.y;
    var hyp = sqrt(dir.x * dir.x + dir.y * dir.y);
    dir.x /= hyp;
    dir.y /= hyp;
    position.x += dir.x * 50 * dt;
    position.y += dir.y * 50 * dt;
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  Matrix4 createComplexTransform(double skewX, double skewY, double scale,
      double rotation, Vector2 translation) {
    return Matrix4.identity()
      ..setEntry(1, 0, skewX)
      ..setEntry(0, 1, skewY)
      ..scale(scale)
      ..rotateZ(rotation)
      ..translate(translation.x, translation.y);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      playerCubit.addPoint();
      other.removeFromParent();
      this.removeFromParent();
      game.add(Explosion(position: position));
    }
  }

  /// Method to apply a pulsating effect to the enemy
  void applyPulsatingEffect() {
    final double originalScale = 1.0;
    final double pulseScale = 1.2;
    final double duration = 0.5;

    void scaleDown() {
      final scaleDownEffect = ScaleEffect.to(
        Vector2.all(originalScale),
        EffectController(duration: duration),
        onComplete: applyPulsatingEffect,
      );
      add(scaleDownEffect);
    }

    final scaleUpEffect = ScaleEffect.to(
      Vector2.all(pulseScale),
      EffectController(duration: duration),
      onComplete: scaleDown,
    );

    add(scaleUpEffect);
  }
}
