import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/github_service.dart';
import '../models/issue_model.dart'; // Import your issue model
import '../models/repo_model.dart'; // Import your repo model

class IssueListScreen extends StatefulWidget {
  final RepoModel repo;

  IssueListScreen({required this.repo});

  @override
  _IssueListScreenState createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  late GitHubService _gitHubService;
  late Future<List<IssueModel>> _issuesFuture;

  @override
  void initState() {
    super.initState();
    _gitHubService = GitHubService();
    _issuesFuture = _gitHubService.fetchIssues(widget.repo.ownerLogin, widget.repo.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issues for ${widget.repo.name}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<IssueModel>>(
        future: _issuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No issues found', style: TextStyle(color: Colors.grey)));
          } else {
            final issues = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.error_outline,
                      color: issue.state == 'open' ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      issue.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      issue.state,
                      style: TextStyle(color: issue.state == 'open' ? Colors.green : Colors.red),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MarkdownBody(
                          data: issue.body,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(fontSize: 14),
                            a: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
