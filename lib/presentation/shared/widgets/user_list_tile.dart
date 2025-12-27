import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onTap;

  const UserListTile({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?'),
      ),
      title: Text(userName),
      subtitle: Text(userEmail),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
