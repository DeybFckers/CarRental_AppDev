// Messages.dart
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/api_connection/conversation.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CarRentals/Details/ConversationDetails.dart';

class MessageScreen extends StatefulWidget {
  final LoggedInUser user;

  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Conversation> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      final response = await http.post(
        Uri.parse(API.getConversation),
        body: {
          "user_type": widget.user.userType,
          "user_id": widget.user.Customer_ID.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          conversations = data
              .map((json) => Conversation.fromJson(
            json,
            _generateConversationTitle(json),
          ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load conversations: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading conversations: $e")),
      );
    }
  }

  String _generateConversationTitle(Map<String, dynamic> json) {
    if (widget.user.userType == 'customer') {
      return 'Chat with Owner #${json['owner_id']}';
    } else {
      return 'Chat with Customer #${json['customer_id']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Inbox - ${widget.user.Customer_Name}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
          : conversations.isEmpty
          ? const Center(
        child: Text(
          "No conversations found.",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return Card(
            color: Colors.grey[800],
            margin:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                convo.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Tap to view conversation',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70),
              ),
              trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.yellow),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationDetailsScreen(
                      user: widget.user,
                      conversation: convo,
                      userType: 'customer',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
