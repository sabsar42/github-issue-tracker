import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GitHubService extends GetxController {
  late final String token;

  final String baseUrl = "https://api.github.com";


  Future<Map<String, dynamic>> fetchUserProfile(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }
  Future<List<dynamic>> fetchUserRepos(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username/repos'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Repos');
    }
  }

  Future<List<dynamic>> fetchPublicReposWithMostIssues() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/search/repositories?q=type:public&sort=issues&order=desc'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load Repos');
    }
  }



  Future<List<dynamic>> fetchRepoIssues(String owner, String repo) async {
    final response = await http.get(
      Uri.parse('$baseUrl/repos/$owner/$repo/issues'),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Issues');
    }
  }
}
