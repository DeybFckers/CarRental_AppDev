import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Inbox Page',
                  style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
        )
    );
  }
}
