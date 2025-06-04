import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Profile Page',
                  style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
        )
    );
  }
}
