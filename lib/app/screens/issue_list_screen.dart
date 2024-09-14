import 'package:flutter/material.dart';
import '../services/github_service.dart';


class IssueListScreen extends StatefulWidget {
  final String owner;
  final String repoName;

  IssueListScreen({required this.owner, required this.repoName});

  @override
  _IssueListScreenState createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  late Future<List<dynamic>> _issues;

  @override
  void initState() {
    super.initState();
    _issues = GitHubService().fetchRepoIssues(widget.owner, widget.repoName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName} Issues'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _issues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No issues found.'));
          }

          final issues = snapshot.data!;
          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return ListTile(
                title: Text(issue['title']),
                subtitle: Text('State: ${issue['state']}'),
                onTap: () {
                  // Optionally, you can navigate to a more detailed issue view
                },
              );
            },
          );
        },
      ),
    );
  }
}
