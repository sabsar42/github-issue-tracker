import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repo_model.dart';
import 'issue_list_screen.dart';

class RepoListScreen extends StatefulWidget {
  RepoListScreen({Key? key}) : super(key: key);

  @override
  _RepoListScreenState createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  final GitHubService _gitHubService = GitHubService();
  List<RepoModel> _repos = [];
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _perPage = 20;

  @override
  void initState() {
    super.initState();
    _fetchRepos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
        _fetchRepos();
      }
    });
  }

  Future<void> _fetchRepos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<RepoModel> newRepos = await _gitHubService.fetchReposWithPagination(
        organization: 'flutter',
        page: _currentPage,
        perPage: _perPage,
      );

      // Sort the repositories alphabetically by name
      newRepos.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {
        _repos.addAll(newRepos);
        _isLoading = false;
        _currentPage++;
        if (newRepos.length < _perPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }





  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: _repos.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: _repos.length + (_hasMore ? 1 : 0), // Add 1 for loading indicator
        itemBuilder: (context, index) {
          if (index == _repos.length) {
            return Center(child: CircularProgressIndicator()); // Loading indicator at the bottom
          }
          return RepoTile(repo: _repos[index]);
        },
      ),
    );
  }
}
class RepoTile extends StatelessWidget {
  final RepoModel repo;

  const RepoTile({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(repo.name),
      subtitle: Text('${repo.openIssuesCount} open issues'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueListScreen(
              repo: repo,
            ),
          ),
        );
      },
    );
  }
}