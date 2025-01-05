
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List results = [];

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    print('Fetching results...');
    final response = await http.get(Uri.parse('http://memorygame77.atwebpages.com/get_all_results.php'));
    print('Response received with status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        results = json.decode(response.body);
        print('Results loaded successfully');
      });
    } else {
      print('Failed to load results with status code: ${response.statusCode}');
      throw Exception('Failed to load results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Results'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: results.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text('User: ${result['username']}'),
            subtitle: Text('Level: ${result['level_number']}, Score: ${result['score']}, Attempts Remaining: ${result['attempts_remaining']}'),
          );
        },
      ),
    );
  }
}