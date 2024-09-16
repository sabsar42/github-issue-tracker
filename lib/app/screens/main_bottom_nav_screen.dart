import 'package:flutter/material.dart';
import 'package:github_issue_tracker/app/screens/repo_list_screen.dart';
import 'package:github_issue_tracker/app/screens/user_profile_screen.dart';


class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    RepoListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 3, 10, 10),
          elevation: 8,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Colors.white70,
          unselectedItemColor: Colors.blueGrey[800],
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_copy_outlined), label: 'Repositories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
