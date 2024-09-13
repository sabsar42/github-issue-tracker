import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueListScreen extends StatelessWidget {
  const IssueListScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchIssues() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/flutter/flutter/issues'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load issues');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Issues')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchIssues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final issues = snapshot.data!;
            return ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];
                return Card(
                  child: ListTile(
                    title: Text(issue['title']),
                    subtitle: Text('Issue #${issue['number']}'),
                    onTap: () {
                      // Navigate to detail screen or show details
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No issues found.'));
          }
        },
      ),
    );
  }
}
