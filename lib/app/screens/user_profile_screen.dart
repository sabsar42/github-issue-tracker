// lib/screens/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../models/user_model.dart';
import '../services/github_service.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_stats_widget.dart';
import '../widgets/view_profile_button_widget.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.put(AuthController());
  late Future<UserModel> userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = GitHubService()
        .fetchUserProfile(_authController.username.value)
        .then((data) => UserModel.fromJson(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _authController.username.value,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w300,
              color: Colors.white, // Ensure the text is visible
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white), // Error text color
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Data Available',
                style: TextStyle(color: Colors.white), // No data text color
              ),
            );
          } else {
            final user = snapshot.data!;
            return buildSingleChildScrollView(user);
          }
        },
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(user: user),
          const SizedBox(height: 30),
          ProfileStats(user: user),
          const SizedBox(height: 30),
          Center(
            child: ViewProfileButton(url: user.htmlUrl),
          ),
        ],
      ),
    );
  }
}
