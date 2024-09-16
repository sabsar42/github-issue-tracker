import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
            radius: 50,
          ),
          const SizedBox(height: 16),

          Text(
            user.name ?? 'No Name Provided',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (user.bio != null)
            Text(
              user.bio!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
