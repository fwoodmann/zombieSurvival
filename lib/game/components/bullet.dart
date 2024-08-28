import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';
import 'package:flame_audio/flame_audio.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference<GeoemtryFight> {
  final double speed = 200.0;
  final Vector2 direction;
  Bullet({
    required this.direction,
    super.position,
  }) : super(size: Vector2(25, 50), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await FlameAudio.audioCache.load('pew.mp3');
    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(16, 16),
      ),
    );
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
    FlameAudio.play('pew.mp3');
    return super.onLoad();
  }

  bool outOfBounds(Vector2 position) {
    if (position.y < -height ||
        -position.y > height ||
        position.x < -width ||
        -position.x > width) {
      return true;
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction.normalized() * speed * dt;
    if (outOfBounds(position)) {
      removeFromParent();
    }
  }
}
