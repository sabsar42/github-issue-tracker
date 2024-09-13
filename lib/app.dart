import 'package:flutter/cupertino.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/screens/main_bottom_nav_screen.dart';
import 'controller_binder.dart';

class GithubIssueTracker extends StatelessWidget {
  const GithubIssueTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainBottomNavScreen(),
      initialBinding:ControllerBinder(),
    );
  }
}