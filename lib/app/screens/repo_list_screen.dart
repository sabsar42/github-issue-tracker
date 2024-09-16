import 'package:flutter/material.dart';

import '../models/repo_model.dart';
import '../services/github_service.dart';
import 'issue_list_screen.dart';

class RepoListScreen extends StatefulWidget {
  const RepoListScreen({super.key});

  @override
  _RepoListScreenState createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  final GitHubService _gitHubService = GitHubService();
  final List<RepoModel> _repos = [];
  final ScrollController _scrollController = ScrollController();
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
      backgroundColor: Colors.black54,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black87,
        title: const Center(
          child: Text(
            'REPOSITORIES',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
      body: _repos.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              controller: _scrollController,
              itemCount: _repos.length + (_hasMore ? 1 : 0),
              // Add 1 for loading indicator
              separatorBuilder: (context, index) => const SizedBox(height: 0.1),
              // Space between items
              itemBuilder: (context, index) {
                if (index == _repos.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54,
                      backgroundColor: Colors.black54,
                    ),
                  ); // Loading indicator at the bottom
                }
                return RepoTile(repo: _repos[index]);
              },
            ),
    );
  }
}

class RepoTile extends StatelessWidget {
  final RepoModel repo;
  const RepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 10,
      tileColor: Colors.black87,
      title: Text(
        repo.name,
        style: const TextStyle(
            fontWeight: FontWeight.w300, fontSize: 16, color: Colors.white),
      ),
      subtitle: Text('${repo.openIssuesCount} open issues'),
      trailing: const Icon(Icons.arrow_forward_ios),
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