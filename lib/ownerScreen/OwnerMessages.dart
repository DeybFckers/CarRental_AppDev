import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:CarRentals/api_connection/conversation.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CarRentals/Details/ConversationDetails.dart';

class OwnerMessageScreen extends StatefulWidget {
  final LoggedInOwner owneruser;

  const OwnerMessageScreen({super.key, required this.owneruser});

  @override
  State<OwnerMessageScreen> createState() => _OwnerMessageScreenState();
}

class _OwnerMessageScreenState extends State<OwnerMessageScreen> {
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
          "user_type": widget.owneruser.userType,
          "user_id": widget.owneruser.Owner_ID.toString(),
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
    return 'Chat with Customer #${json['customer_id']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // Dark background
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Inbox - ${widget.owneruser.Owner_Name}',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme:  IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.yellow[900]))
          : conversations.isEmpty
          ?  Center(
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
            color: const Color(0xFF1F1F1F),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                convo.title,
                style:  TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Tap to view conversation',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationDetailsScreen(
                      user: widget.owneruser,
                      conversation: convo,
                      userType: 'owner',
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
