import 'package:flutter/material.dart';  // Use Material package instead of Cupertino for consistency
import 'package:get/get.dart';
import 'package:github_issue_tracker/app/screens/auth/sign_in.dart';

import 'app/controller/auth_controller.dart';
import 'app/screens/main_bottom_nav_screen.dart';

class GithubIssueTracker extends StatelessWidget {
  const GithubIssueTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    );
  }
}
