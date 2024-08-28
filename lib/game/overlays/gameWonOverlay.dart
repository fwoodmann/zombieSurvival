import 'package:flutter/material.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';

class GameWonOverlay extends StatelessWidget {
  final GeoemtryFight gameRef;

  const GameWonOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You Won!',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove('GameWon');
              gameRef.resetGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
