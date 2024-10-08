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
      backgroundColor: const Color.fromARGB(255, 12, 15, 17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _authController.username.value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined, color: Colors.white),
            onPressed: () {
              _showSignOutConfirmationDialog(context);
            },
          ),
        ],
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
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Data Available',
                style: TextStyle(color: Colors.white),
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
            child: InkWell(
              child: ViewProfileButton(url: user.htmlUrl),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.grey,
          title: const Text(
            'CONFIRM SIGN OUT',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: const Text(
                'SIGN OUT',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _authController.signOut();
              },
            ),
          ],
        );
      },
    );
  }
}
