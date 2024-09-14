// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = GitHubService().fetchUserProfile(widget.username)
        .then((data) => UserModel.fromJson(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Data Available'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                    radius: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(user.bio),
                  SizedBox(height: 16),
                  Text('Public Repositories: ${user.publicRepos}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement navigation to the README file if needed
                    },
                    child: Text('View Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
