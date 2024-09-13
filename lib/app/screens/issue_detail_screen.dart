import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IssueDetailScreen extends StatelessWidget {
  final Map<String, dynamic> issue;

  const IssueDetailScreen({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Issue #${issue['number']}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MarkdownBody(
          data: issue['body'] ?? 'No description available',
        ),
      ),
    );
  }
}
