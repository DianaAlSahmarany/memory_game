import 'package:flutter/material.dart';
import 'memory_game_page.dart';

class LevelSelectionPage extends StatefulWidget {
  final String username;
  final int userId;
  final bool timerEnabled; // Add timerEnabled parameter

  const LevelSelectionPage({
    super.key,
    required this.username,
    required this.userId,
    required this.timerEnabled, // Add timerEnabled parameter
  });

  @override
  State<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  int selectedLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.purpleAccent.withOpacity(0.7)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: selectedLevel,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedLevel = newValue!;
                  });
                },
                items: <int>[1, 2].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("Level $value"),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoryGamePage(
                        username: widget.username,
                        userId: widget.userId,
                        level: selectedLevel,
                        timerEnabled: widget.timerEnabled, // Pass timerEnabled parameter
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text(
                  "Go",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}