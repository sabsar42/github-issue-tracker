import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

import '../screens/auth/sign_in.dart';

class AuthController extends GetxController {
  var username = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to set the username
  void setUsername(String newUsername) {
    username.value = newUsername;
    update();
  }

  // Method to sign out from Firebase and GitHub
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

//

      // If you are using GitHub sign-in, add GitHub sign-out logic here
      GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'YOUR_GITHUB_CLIENT_ID',
        clientSecret: 'YOUR_GITHUB_CLIENT_SECRET',
        redirectUrl: 'YOUR_GITHUB_REDIRECT_URL',
      );

      // If you need to clear any session or token from GitHub
      // await gitHubSignIn.clearSession();

      // Clear the username in the controller
      setUsername('');

      // Navigate to SignIn screen after sign out
      Get.offAll(() => SignIn());

    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar('Error', 'Failed to sign out');
    }
  }
}
