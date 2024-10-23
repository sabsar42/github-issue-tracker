import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_issue_tracker/app/screens/auth/sign_in.dart';
import 'app/controller/auth_controller.dart';

class GithubIssueTracker extends StatelessWidget {
  const GithubIssueTracker({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    );
  }
}