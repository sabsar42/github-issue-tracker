import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../services/github_service.dart';
import '../models/repo_model.dart';

class IssueListScreen extends StatefulWidget {
  final RepoModel repo;

  IssueListScreen({Key? key, required this.repo}) : super(key: key);

  @override
  _IssueListScreenState createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  final GitHubService _gitHubService = GitHubService();
  List<IssueModel> _issues = [];
  List<IssueModel> _filteredIssues = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _perPage = 20;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchIssues();
  }
  Future<void> _fetchIssues() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<IssueModel> newIssues = await _gitHubService.fetchIssuesWithPagination(
        repo: widget.repo.name,
        page: _currentPage,
        perPage: _perPage,
      );

      print('Fetched ${newIssues.length} issues'); // Debug log

      // Filter issues that do not contain 'flutter' in the title
      newIssues = newIssues.where((issue) => !issue.title.toLowerCase().contains('flutter')).toList();

      print('Filtered ${newIssues.length} issues'); // Debug log

      setState(() {
        _issues.addAll(newIssues);
        _filteredIssues = _filterIssues(_searchQuery);
        _isLoading = false;
        _currentPage++;
        if (newIssues.length < _perPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      print('Error fetching issues: $e'); // Debug log
      setState(() {
        _isLoading = false;
      });
    }
  }


  List<IssueModel> _filterIssues(String query) {
    return _issues.where((issue) => issue.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredIssues = _filterIssues(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues for ${widget.repo.name}'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                labelText: 'Search Issues',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _filteredIssues.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _filteredIssues.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredIssues.length) {
            return Center(child: CircularProgressIndicator());
          }
          return ListTile(
            title: Text(_filteredIssues[index].title),
            subtitle: Text('Issue #${_filteredIssues[index].number}'),
            onTap: () {
              // Navigate to issue details (optional)
            },
          );
        },
      ),
    );
  }
}
