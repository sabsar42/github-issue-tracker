import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../main_bottom_nav_screen.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignIn extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  SignIn({super.key});

  // GitHub sign-in method
  Future<void> signInWithGitHub(BuildContext context) async {
    try {
      // Access the environment variables
      final clientId = dotenv.env['CLIENT_ID']!;
      final clientSecret = dotenv.env['CLIENT_SECRET']!;
      final redirectUrl = dotenv.env['CLIENT_CALLBACK_URL']!;

      // Create GitHubSignIn instance
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
          clientId: clientId,
          clientSecret: clientSecret,
          redirectUrl: redirectUrl);

      // Trigger the sign-in flow
      final result = await gitHubSignIn.signIn(context);

      // Check if the sign-in was successful
      if (result.status == GitHubSignInResultStatus.ok) {
        // Create a credential from the access token
        final githubAuthCredential =
        GithubAuthProvider.credential(result.token!);

        // Sign in to Firebase using GitHub credential
        await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

        // Show success snack bar
        showSnackBar(context, "Signed in successfully with GitHub!");

        // Navigate to the main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      } else {
        // Handle GitHub sign-in failure
        showSnackBar(context, "GitHub sign-in failed: ${result.status}");
      }
    } catch (error) {
      // Handle any errors
      showSnackBar(context, "Error during sign-in: $error");
    }
  }

  // Snack bar display method
  void showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                  child: TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'GitHub Username',
                      floatingLabelStyle: const TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      _authController.setUsername(usernameController.text);

                      // Call GitHub sign-in
                      await signInWithGitHub(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4.0,
                      backgroundColor: Colors.black,
                      fixedSize: const Size(350.0, 60.0),
                    ),
                    child: const Text(
                      "Sign In with GitHub",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
