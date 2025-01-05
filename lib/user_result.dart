import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserResult extends StatelessWidget {
  final int userId;

  const UserResult({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> fetchResults() async {
    final response = await http.post(
      Uri.parse('http://memorygame77.atwebpages.com/get_user_results.php'),
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            final results = snapshot.data!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text('Level ${result['level_id']}'),
                  subtitle: Text('Score: ${result['score']} - Attempts Remaining: ${result['attempts_remaining']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}