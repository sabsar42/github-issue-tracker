import 'package:flutter/material.dart';
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
      ),
      body: FutureBuilder<List<IssueModel>>(
        future: _issuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No issues found'));
          } else {
            final issues = snapshot.data!;

            return ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];

                return ListTile(
                  title: Text(issue.title),
                  subtitle: Text(issue.body),
                  trailing: Text(issue.state),
                  onTap: () {
                    // Handle issue tap if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
