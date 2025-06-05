// import 'package:flutter/material.dart';
// import 'package:CarRentals/api_connection/LoggedInUser.dart';
// import 'package:CarRentals/api_connection/conversation.dart';
// import 'package:CarRentals/api_connection/api_connection.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:CarRentals/Details/ConversationDetails.dart';
//
//
// class MessageScreen extends StatefulWidget {
//   final LoggedInUser user;
//
//   const MessageScreen({super.key, required this.user});
//
//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends State<MessageScreen> {
//   List<Conversation> conversations = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchConversations();
//   }
//
//   Future<void> fetchConversations() async {
//     try {
//       final response = await http.post(
//         Uri.parse(API.getConversation),
//         body: {
//           "user_type": widget.user.userType,
//           "user_id": widget.user.Customer_ID.toString(),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         setState(() {
//           conversations = data
//               .map((json) => Conversation.fromJson(
//             json,
//             json['title'] ?? 'Conversation',
//           ))
//               .toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load conversations");
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Inbox - ${widget.user.Customer_Name}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : conversations.isEmpty
//           ? const Center(child: Text("No conversations found."))
//           : ListView.builder(
//         itemCount: conversations.length,
//         itemBuilder: (context, index) {
//           final convo = conversations[index];
//           return ListTile(
//             title: Text(convo.title),
//             subtitle: Text(
//               convo.messages.isNotEmpty
//                   ? convo.messages.last.text
//                   : 'No messages yet',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ConversationDetailsScreen(
//                     user: widget.user,
//                     conversation: convo,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }