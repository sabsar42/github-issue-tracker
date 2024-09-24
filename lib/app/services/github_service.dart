import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/issue_model.dart';
import '../models/repo_model.dart';

class GitHubService {
  late final String token;
  final String baseUrl = "https://api.github.com";

  Future<Map<String, dynamic>> fetchUserProfile(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );
    print('Rate Limit Remaining: ${response.headers['x-ratelimit-remaining']}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<RepoModel>> fetchReposWithPagination({
    String? organization,
    int page = 1,
    int perPage = 20,
  }) async {
    List<RepoModel> repos = [];

    try {
      final publicUrl = Uri.parse('https://api.github.com/search/repositories?q=issues:>0&sort=issues&order=desc&page=$page&per_page=$perPage');
      final publicResponse = await http.get(publicUrl);

      if (publicResponse.statusCode == 200) {
        final publicData = json.decode(publicResponse.body);
        List<dynamic> publicJsonData = publicData['items'];
        List<RepoModel> publicRepos = publicJsonData.map((repoJson) => RepoModel.fromJson(repoJson)).toList();
        repos.addAll(publicRepos);
      } else {
        throw Exception('Failed to load public repositories');
      }

      // Fetching organization repositories
      if (organization != null && organization.isNotEmpty) {
        final orgUrl = Uri.parse('https://api.github.com/orgs/$organization/repos?page=$page&per_page=$perPage');
        final orgResponse = await http.get(orgUrl);

        if (orgResponse.statusCode == 200) {
          List<dynamic> orgJsonData = json.decode(orgResponse.body);
          List<RepoModel> orgRepos = orgJsonData
              .map((repoJson) => RepoModel.fromJson(repoJson))
              .toList();
          repos.addAll(orgRepos);
        } else {
          throw Exception('Failed to load organization repositories');
        }
      }

      repos
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return repos;
    } catch (e) {
      throw Exception('Error fetching repositories: $e');
    }
  }

  Future<List<IssueModel>> fetchIssues(String owner, String repo, {int page = 1, int perPage = 30}) async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/$owner/$repo/issues?state=open&page=$page&per_page=$perPage'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IssueModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }

  Future<List<IssueModel>> searchIssuesByTitle(String title) async {
    final url = 'https://api.github.com/search/issues?q=$title';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      return items.map((json) => IssueModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }
}
