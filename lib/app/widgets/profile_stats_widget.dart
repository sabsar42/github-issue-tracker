import 'package:flutter/material.dart';
import '../models/user_model.dart';


class ProfileStats extends StatelessWidget {
  final UserModel user;

  const ProfileStats({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Repositories', user.publicRepos.toString()),
        _buildStatCard('Followers', user.followers.toString()),
        _buildStatCard('Following', user.following.toString()),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
