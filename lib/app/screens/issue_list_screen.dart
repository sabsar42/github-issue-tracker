import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/issue_model.dart';
import '../models/repo_model.dart';
import '../services/github_service.dart';

class IssueListScreen extends StatefulWidget {
  final RepoModel repo;
  IssueListScreen({required this.repo});
  @override
  _IssueListScreenState createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  late GitHubService _gitHubService;
  late Future<List<IssueModel>> _issuesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _gitHubService = GitHubService();
    _issuesFuture =
        _gitHubService.fetchIssues(widget.repo.ownerLogin, widget.repo.name);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Issues: ${widget.repo.name}",
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.w100),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Issues...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<IssueModel>>(
              future: _issuesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No issues found',
                          style: TextStyle(color: Colors.white)));
                } else {
                  final issues = snapshot.data!;
                  final filteredIssues = issues
                      .where((issue) =>
                          issue.title?.toLowerCase().contains(_searchQuery) ??
                          false)
                      .toList();
                  return IssueListView(filteredIssues);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView IssueListView(List<IssueModel> issues) {
    return ListView.builder(
      padding: EdgeInsets.all(9.0),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return Card(
          color: Colors.grey[900],
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ExpansionTile(
            leading: Icon(
              Icons.commit,
              color: issue.state == 'open' ? Colors.green : Colors.red,
              size: 24,
            ),
            title: Text(
              issue.title ?? 'No Title',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white),
            ),
            subtitle: Text(
              issue.state.toUpperCase(),
              style: TextStyle(
                color: issue.state == 'open' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            childrenPadding: EdgeInsets.all(16.0),
            children: [
              expandedMarkDown(issue),
            ],
          ),
        );
      },
    );
  }

  MarkdownBody expandedMarkDown(IssueModel issue) {
    return MarkdownBody(
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
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                color: Colors.black54,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
                child: Text('Image failed to load',
                    style: TextStyle(color: Colors.red)));
          },
        );
      },
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(fontSize: 14, color: Colors.white70),
        a: TextStyle(color: Colors.blueGrey),
        h1: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        h2: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        h3: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
