import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../services/github_service.dart';
import '../main_bottom_nav_screen.dart';

class SignIn extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final GitHubService _gitHubService = GitHubService();

  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/github-logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Github Issue Tracker',
                  style: TextStyle(
                    fontFamily: 'FontMain',
                    fontSize: 28,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      _authController.setUsername("Guest User");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainBottomNavScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4.0,
                      backgroundColor: Color.fromARGB(255, 247, 242, 250),
                      fixedSize: const Size(350.0, 60.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_circle_rounded,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Guest User",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromARGB(255, 79, 40, 29),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _gitHubService.signInWithGitHub(context);
                      _authController.setUsername(
                          _gitHubService.githubUsername ??
                              "No username available");


                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4.0,
                      backgroundColor: Colors.black,
                      fixedSize: const Size(350.0, 60.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.github,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Sign In with GitHub",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
