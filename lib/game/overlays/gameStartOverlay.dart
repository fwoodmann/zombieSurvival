import 'package:flutter/material.dart';
import 'package:zombieSurvival/game/zombieSurvival.dart';

class StartGameOverlay extends StatelessWidget {
  final GeoemtryFight gameRef;

  const StartGameOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Zombie Survival',
            style: TextStyle(fontSize: 40, color: Colors.black),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              gameRef.startGame();

              gameRef.overlays.remove('StartGame'); // Hide the overlay
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
