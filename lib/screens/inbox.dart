import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';

class InboxScreen extends StatelessWidget {
  final LoggedInUser user;

  InboxScreen({super.key, required this.user});

  // Mutable conversations list
  final List<Conversation> conversations = [
    Conversation(
      title: 'Toyota Vios Owner',
      messages: [
        Message(text: 'Hi! Is the car available on the 12th?', isMe: true),
        Message(text: 'Yes, it’s available from 10 AM.', isMe: false),
        Message(text: 'Great! I’ll book it now.', isMe: true),
        Message(text: 'Perfect. I’ll prepare it for you.', isMe: false),
      ],
    ),
    Conversation(
      title: 'Suzuki Ertiga Owner',
      messages: [
        Message(text: 'Is the car still available tomorrow?', isMe: true),
        Message(text: 'Yes, it is.', isMe: false),
        Message(text: 'Thank you!', isMe: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inbox - ${user.Customer_Name}'),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ListTile(
            title: Text(convo.title),
            subtitle: Text(
              convo.messages.isNotEmpty
                  ? convo.messages.last.text
                  : 'No messages yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationScreen(conversation: convo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  Message({required this.text, required this.isMe});
}

class Conversation {
  final String title;
  List<Message> messages;
  Conversation({required this.title, required this.messages});
}

class ConversationScreen extends StatefulWidget {
  final Conversation conversation;

  const ConversationScreen({super.key, required this.conversation});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.conversation.messages.add(Message(text: text, isMe: true));
      // Simulate a reply from the owner after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          widget.conversation.messages.add(
            Message(text: 'Thanks for your message!', isMe: false),
          );
        });
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.conversation.messages[
                widget.conversation.messages.length - 1 - index];
                return Align(
                  alignment:
                  msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.yellow[800] : const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isMe ? Colors.black : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
