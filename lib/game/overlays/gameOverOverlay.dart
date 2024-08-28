import 'package:flutter/material.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart'; // Replace with your actual game class import

class GameOverOverlay extends StatelessWidget {
  final GeoemtryFight gameRef;

  const GameOverOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 40, color: Colors.black),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove('GameOver');
              gameRef.resetGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
