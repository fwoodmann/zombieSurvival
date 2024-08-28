import 'dart:async';
import 'package:flame/components.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';

class Explosion extends SpriteAnimationComponent
    with HasGameReference<GeoemtryFight> {
  Explosion({
    super.position,
  }) : super(
          size: Vector2.all(150),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: .1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
