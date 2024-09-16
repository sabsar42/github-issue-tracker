class RepoModel {
  final String name;
  final String description;
  final int openIssuesCount;
  final String language;
  final String ownerLogin;
  final List<String> topics;

  RepoModel({
    required this.name,
    required this.description,
    required this.openIssuesCount,
    required this.language,
    required this.ownerLogin,
    required this.topics,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      name: json['name'] ?? 'Unnamed Repo',
      description: json['description'] ?? 'No description',
      openIssuesCount: json['open_issues_count'] ?? 0,
      language: json['language'] ?? 'Unknown',
      ownerLogin: json['owner']['login'] ?? 'Unknown',
      topics: (json['topics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
