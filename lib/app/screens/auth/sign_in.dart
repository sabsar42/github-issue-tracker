// lib/screens/auth/sign_in.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../main_bottom_nav_screen.dart';

class SignIn extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  SignIn({super.key});

  void showSnackBar(String message) {
    var snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar);
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
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                  child: TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Github Username',
                      floatingLabelStyle: const TextStyle(
                          color: Colors.brown),
                      hintText: '',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _authController.setUsername(usernameController.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainBottomNavScreen(),
                        ),
                      );
                      showSnackBar("Sign In Successful");
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
                      "Continue",
                      style: TextStyle(
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
