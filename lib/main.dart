import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Match2Game());
}

class Match2Game extends StatelessWidget {
  const Match2Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HW3 Calvin Wong: Match 2 Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int numPairs = 8;
  List<String> cardValues = [];
  List<bool> cardFlipped = [];
  List<int> cardIndices = [];
  int? firstCardIndex;
  int? secondCardIndex;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    cardValues = List.generate(numPairs, (index) => 'Card $index').expand((x) => [x, x]).toList();
    cardValues.shuffle(Random());
    cardFlipped = List.generate(16, (index) => false);
    cardIndices = List.generate(16, (index) => index);
    score = 0;
  }

  //game logic when tapping cards
  void onCardTap(int index) {
    if (cardFlipped[index] || (firstCardIndex != null && secondCardIndex != null)) return;

    setState(() {
      cardFlipped[index] = true;
      //checks if card selections are empty
      if (firstCardIndex == null) {
        firstCardIndex = index;
      } else if (secondCardIndex == null) {
        secondCardIndex = index;

        // checks for match
        if (cardValues[firstCardIndex!] == cardValues[secondCardIndex!]) {
          score++;
          // reset indices after checking
          firstCardIndex = null;
          secondCardIndex = null;
          if (score == numPairs) {
            // game finished
            _showGameFinishedDialog();
          }
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              cardFlipped[firstCardIndex!] = false;
              cardFlipped[secondCardIndex!] = false;
              // reset indices after checking
              firstCardIndex = null;
              secondCardIndex = null;
            });
          });
        }

      }
    });
  }

  void _showGameFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("You Win!"),
          content: const Text("You've matched all pairs!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initializeGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HW3 Calvin Wong: Match 2 Game"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: cardValues.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCardTap(index),
            child: Card(
              color: cardFlipped[index] ? Colors.white : Colors.blue,
              child: Center(
                child: cardFlipped[index]
                    ? Text(cardValues[index], style: const TextStyle(fontSize: 20))
                    : Image.asset('assets/cardback.jpg'), // Use the image for the back of the card
              ),
            ),
          );
        },
      ),
    );
  }
}
