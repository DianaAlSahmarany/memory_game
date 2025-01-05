import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_result.dart'; // Import the UserResult page

class MemoryGamePage extends StatefulWidget {
  final String username;
  final int userId;
  final int level;
  final bool timerEnabled;

  const MemoryGamePage({
    super.key,
    required this.username,
    required this.userId,
    required this.level,
    required this.timerEnabled,
  });

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  int timeLeft = 60;
  int score = 0;
  int attempts = 3;
  Timer? timer;
  List<String> images = [];
  List<bool> revealed = [];
  int firstSelected = -1;

  final Map<String, String> parentChildPairs = {
    "assets/lion.png": "assets/cub.png",
    "assets/dog.png": "assets/puppy.png",
    "assets/cat.png": "assets/kitten.png",
    "assets/elephant.png": "assets/calf.png",
  };

  @override
  void initState() {
    initializeLevel(widget.level); // Initialize the selected level
    super.initState();
  }

  void initializeLevel(int level) async {
    if (level == 1) {
      images = [
        "assets/icons/1.png",
        "assets/icons/2.png",
        "assets/icons/3.png",
        "assets/icons/4.png",
        "assets/icons/5.png",
        "assets/icons/6.png",
        "assets/icons/7.png",
        "assets/icons/8.png",
      ];
    } else {
      images = [
        "assets/lion.png",
        "assets/cub.png",
        "assets/dog.png",
        "assets/puppy.png",
        "assets/cat.png",
        "assets/kitten.png",
        "assets/elephant.png",
        "assets/calf.png",
      ];
    }

    images = [...images, ...images];
    images.shuffle();

    setState(() {
      revealed = List<bool>.filled(images.length, true);
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      revealed = List<bool>.filled(images.length, false);
    });

    if (widget.timerEnabled) {
      startTimer();
    } else {
      setState(() {
        timeLeft = 0;
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showGameOverDialog("Time's Up!");
        }
      });
    });
  }

  void revealCard(int index) async {
    if (!revealed[index]) {
      setState(() {
        revealed[index] = true;
      });

      if (firstSelected == -1) {
        firstSelected = index;
      } else {
        bool isMatch = widget.level == 2
            ? (parentChildPairs[images[firstSelected]] == images[index] ||
            parentChildPairs[images[index]] == images[firstSelected])
            : (images[firstSelected] == images[index]);

        if (isMatch) {
          score += 10;
          if (revealed.every((element) => element)) {
            timer?.cancel();
            showWinDialog();
          }
        } else {
          attempts--;
          if (attempts == 0) {
            timer?.cancel();
            showGameOverDialog("No more attempts!");
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
            setState(() {
              revealed[firstSelected] = false;
              revealed[index] = false;
            });
          }
        }
        firstSelected = -1;
      }
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: const Text("You matched all cards! Go ahead to the next level."),

      ),
    );
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(message),
      ),
    );
  }

  void saveResultAndNavigate() async {
    await saveResult();
    if (widget.level == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MemoryGamePage(
            username: widget.username,
            userId: widget.userId,
            level: 2,
            timerEnabled: widget.timerEnabled,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserResult(
            userId: widget.userId,
          ),
        ),
      );
    }
  }

  Future<void> saveResult() async {
    var url = Uri.parse('http://memorygame77.atwebpages.com/save_result.php');
    var response = await http.post(url, body: {
      'user_id': widget.userId.toString(),
      'level_id': widget.level.toString(),
      'score': score.toString(),
      'attempts_remaining': attempts.toString(),
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Result saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save result!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memory Game - ${widget.username}"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Time: $timeLeft - Score: $score - Attempts: $attempts",
            style: const TextStyle(fontSize: 24),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => revealCard(index),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: revealed[index] ? Colors.white : Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: revealed[index]
                      ? Image.asset(images[index])
                      : Container(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              List<bool> temp = revealed;
              setState(() {
                revealed = List<bool>.filled(images.length, true);
              });
              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                revealed = temp;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              backgroundColor: Colors.purpleAccent,
            ),
            child: const Text(
              "Hint",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveResultAndNavigate,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              backgroundColor: Colors.purpleAccent,
            ),
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}