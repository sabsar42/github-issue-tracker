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
        title: Text(
          "Issues for ${widget.repo.name}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<IssueModel>>(
        future: _issuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No issues found', style: TextStyle(color: Colors.black)));
          } else {
            final issues = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];

                return Card(
                  color: Colors.grey[100],
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.error_outline,
                      color: issue.state == 'open' ? Colors.green : Colors.red,
                      size: 24,
                    ),
                    title: Text(
                      issue.title ?? 'No Title',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    subtitle: Text(
                      issue.state.toUpperCase(),
                      style: TextStyle(
                        color: issue.state == 'open' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    tilePadding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                    childrenPadding: EdgeInsets.all(16.0),
                    children: [
                      MarkdownBody(
                        data: issue.body ?? 'No Details Available',
                        imageBuilder: (uri, title, alt) {
                          return Image.network(
                            uri.toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Image failed to load', style: TextStyle(color: Colors.red)));
                            },
                          );
                        },
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(fontSize: 14, color: Colors.black87),
                          a: TextStyle(color: Colors.blueGrey),
                          h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          h2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          h3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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