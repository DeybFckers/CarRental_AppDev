// ConversationDetails.dart
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart'; // Your owner class
import 'package:CarRentals/api_connection/message.dart';
import 'package:CarRentals/api_connection/conversation.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationDetailsScreen extends StatefulWidget {
  final dynamic user; // Can be LoggedInUser or LoggedInOwner
  final Conversation conversation;
  final String userType; // 'customer' or 'owner'

  const ConversationDetailsScreen({
    super.key,
    required this.user,
    required this.conversation,
    required this.userType,
  });

  @override
  State<ConversationDetailsScreen> createState() =>
      _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {
  List<Message> messages = [];
  bool isLoading = true;
  bool isSending = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int get userId {
    if (widget.userType == 'customer') {
      return (widget.user as LoggedInUser).Customer_ID;
    } else {
      return (widget.user as LoggedInOwner).Owner_ID;
    }
  }

  String get userName {
    if (widget.userType == 'customer') {
      return (widget.user as LoggedInUser).Customer_Name;
    } else {
      return (widget.user as LoggedInOwner).Owner_Name;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await http.post(
        Uri.parse(API.getMessage),
        body: {
          "conversation_id": widget.conversation.conversationId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages = data
              .map((json) => Message.fromJson(
            json,
            currentUserId: userId,
            userType: widget.userType,
          ))
              .toList();
          isLoading = false;
        });
        _scrollToBottom();
      } else {
        throw Exception("Failed to load messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading messages: $e")),
      );
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || isSending) return;

    setState(() => isSending = true);

    try {
      final response = await http.post(
        Uri.parse(API.sendMessage),
        body: {
          "conversation_id": widget.conversation.conversationId,
          "user_type": widget.userType,
          "sender_id": userId.toString(),
          "message_text": text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            messages.add(Message(
              text: text,
              isMe: true,
              sentAt: DateTime.now(),
              senderType: widget.userType,
              senderId: userId,
            ));
          });
          _controller.clear();
          _scrollToBottom();
        } else {
          throw Exception(responseData['error'] ?? 'Failed to send message');
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send message: $e")),
      );
    } finally {
      setState(() => isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.conversation.title, style: const TextStyle(color: Colors.white)),
            Text(
              '${widget.userType == 'customer' ? 'Customer' : 'Owner'}: $userName',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.yellow[900]),
            onPressed: fetchMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors
                .yellow[900]))
                : messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No messages yet.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start the conversation!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth:
                      MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? Colors.yellow[900]
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color:
                            msg.isMe ? Colors.black : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${msg.sentAt.hour}:${msg.sentAt.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: msg.isMe
                                ? Colors.black87
                                : Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[900],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: isSending
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                        : const Icon(Icons.send, color: Colors.black),
                    onPressed: isSending ? null : sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}