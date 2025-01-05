import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_page.dart'; // Import the LoginPage

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String gender = 'Male'; // Default gender
  bool timerEnabled = false; // Default timer setting
  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://memorygame77.atwebpages.com/register.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'gender': gender,
        'timer_enabled': timerEnabled ? '1' : '0',
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(), // Navigate to LoginPage
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
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Male'),
                    leading: Radio<String>(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Female'),
                    leading: Radio<String>(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Enable Timer'),
              value: timerEnabled,
              onChanged: (bool? value) {
                setState(() {
                  timerEnabled = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}