import 'package:CarRentals/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';

class ProfileScreen extends StatelessWidget {
  final LoggedInUser user;
  const ProfileScreen({super.key, required this.user});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog on cancel
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.yellow,
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${user.Customer_Name}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '${user.Customer_Email}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  ProfileInfoTile(
                    label: 'Name',
                    value: '${user.Customer_Name}',
                  ),
                  ProfileInfoTile(
                    label: 'Address',
                    value: '${user.Customer_Address}',
                  ),
                  ProfileInfoTile(
                    label: 'Contact',
                    value: '${user.Customer_Contact}',
                  ),
                  ProfileInfoTile(
                    label: 'Email',
                    value: '${user.Customer_Email}',
                  ),
                  const Divider(color: Colors.grey),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Log Out',
                      style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
