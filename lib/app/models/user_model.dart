// lib/models/user_model.dart
class UserModel {
  final String login;
  final String name;
  final String bio;
  final int publicRepos;
  final String avatarUrl;
  final String htmlUrl;

  UserModel({
    required this.login,
    required this.name,
    required this.bio,
    required this.publicRepos,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'],
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      publicRepos: json['public_repos'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
    );
  }
}
