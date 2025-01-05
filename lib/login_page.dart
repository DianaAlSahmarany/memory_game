import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'level_selection_page.dart';
import 'register_page.dart';
import 'results_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://memorygame77.atwebpages.com/login.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        int userId = int.parse(data['user']['id'].toString());
        bool timerEnabled = data['user']['timer_enabled'] == '1';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelSelectionPage(
              username: usernameController.text,
              userId: userId,
              timerEnabled: timerEnabled,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.purpleAccent.withOpacity(0.7)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Memory Game",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: TextField(
                    controller: usernameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    backgroundColor: Colors.purpleAccent,
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : const Text(
                    "Login",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, color: Colors.purpleAccent),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    backgroundColor: Colors.purpleAccent,
                  ),
                  child: const Text(
                    "All Results",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}