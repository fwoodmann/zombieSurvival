import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:zombieSurvival/game/utils/statsCubit.dart';

class PlayerDisplayComponent extends PositionComponent {
  final PlayerCubit playerCubit;
  late TextComponent _livesTextComponent;
  late TextComponent _scoreTextComponent;

  PlayerDisplayComponent({required this.playerCubit})
      : super(position: Vector2(10, 10), size: Vector2(200, 70));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _livesTextComponent = TextComponent(
      text: 'Lives: ${playerCubit.state.lives}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
    add(_livesTextComponent);

    _livesTextComponent.position = Vector2(0, 0);

    _scoreTextComponent = TextComponent(
      text: 'Score: ${playerCubit.getPoints()}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
    add(_scoreTextComponent);
    _scoreTextComponent.position = Vector2(0, 30);

    // Update text when state changes
    playerCubit.stream.listen((state) {
      _livesTextComponent.text = 'Lives: ${state.lives}';
      _scoreTextComponent.text = 'Score: ${playerCubit.getPoints()}';
    });
  }
}
