import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_issue_tracker/app/screens/repo_list_screen.dart';
import 'package:github_issue_tracker/app/screens/user_profile_screen.dart';

import '../controller/auth_controller.dart';
import 'issue_list_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final username = _authController.username.value;
        return IndexedStack(
          index: _selectedIndex,
          children: [
            RepoListScreen(username: username),
            ProfileScreen(username: username),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_copy_outlined), label: 'Issues'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
