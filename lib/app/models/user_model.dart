// lib/models/user_model.dart

class UserModel {
  final String login;
  final int id;
  final String avatarUrl;
  final String url;
  final String htmlUrl;
  final String followersUrl;
  final String followingUrl;
  final String? name;
  final String? bio;
  final int followers;
  final int following;
  final int publicRepos;
  final String? location;


  UserModel({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    this.name,
    this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'],
      id: json['id'],
      avatarUrl: json['avatar_url'],
      url: json['url'],
      htmlUrl: json['html_url'],
      followersUrl: json['followers_url'],
      followingUrl: json['following_url'],
      name: json['name'],
      bio: json['bio'],
      followers: json['followers'],
      following: json['following'],
      publicRepos: json['public_repos'],
      location: json['location'],
    );
  }
}
