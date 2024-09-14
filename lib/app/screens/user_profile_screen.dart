// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/auth_controller.dart';
import '../models/user_model.dart';
import '../services/github_service.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.put(AuthController());
  late Future<UserModel> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = GitHubService().fetchUserProfile(_authController.username.value)
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
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                      radius: 50,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.name ?? 'No Name Provided',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  if (user.bio != null)
                    Text(user.bio!, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  if (user.location != null)
                    Text('Location: ${user.location}',
                        style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Public Repositories: ${user.publicRepos}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Followers: ${user.followers}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Following: ${user.following}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement navigation to user's GitHub profile
                      _launchURL(user.htmlUrl);
                    },
                    child: Text('View GitHub Profile'),
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

  // Helper function to open URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
