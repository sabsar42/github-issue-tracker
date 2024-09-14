import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/auth_controller.dart';
import '../services/github_service.dart';
import 'issue_list_screen.dart';

class RepoListScreen extends StatefulWidget {

  RepoListScreen({Key? key}) : super(key: key);

  @override
  _RepoListScreenState createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  final AuthController _authController = Get.put(AuthController());

  late Future<List<dynamic>> _repos;
  late Future<List<dynamic>> _publicRepos;
  @override
  void initState() {
    super.initState();
    _repos = GitHubService().fetchUserRepos(_authController.username.value);
    _publicRepos = GitHubService().fetchPublicReposWithMostIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _publicRepos ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No repositories found'));
          }

          final repos = snapshot.data!;
          return ListView.builder(
            itemCount: repos.length,
            itemBuilder: (context, index) {
              final repo = repos[index];
              return ListTile(
                title: Text(repo['name']),
                subtitle: Text(repo['description'] ?? 'No description'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssueListScreen(
                        owner: repo['owner']['login'],
                        repoName: repo['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
