import 'dart:convert';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'package:CarRentals/InboxStatus/ReviewSection.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/conversation.dart';
import 'package:CarRentals/Details/ConversationDetails.dart';


class CompleteReview extends StatefulWidget {
  final BookingDetails booking;
  final LoggedInUser user;

  const CompleteReview({super.key, required this.booking, required this.user});

  @override
  State<CompleteReview> createState() => _CompleteReview();
}

class _CompleteReview extends State<CompleteReview> {
  bool hasReviewed = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkIfReviewed();
  }

  Future<void> checkIfReviewed() async {
    try {
      var response = await http.post(
        Uri.parse(API.checkReview), // <-- Replace with your real API URL
        body: {
          "Customer_ID": widget.user.Customer_ID.toString(),
          "Car_ID": widget.booking.carId.toString(),
        },
      );
      var data = jsonDecode(response.body);
      setState(() {
        hasReviewed = data['Reviewed'] ?? false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasReviewed = false;
        isLoading = false;
      });
      // Optional: show error or retry
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('${booking.brand} ${booking.model}')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${booking.brand} ${booking.model}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              booking.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              '${booking.brand} ${booking.model}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      '${booking.ownerName}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Iconsax.message, color: Colors.white),
                  onPressed: () async {
                    try {
                      // Create or get existing conversation
                      final response = await http.post(
                        Uri.parse(API.createConversation),
                        body: {
                          'customer_id': widget.user.Customer_ID.toString(),
                          'owner_id': widget.booking.ownerId.toString(),
                        },
                      );

                      if (response.statusCode == 200) {
                        final responseData = jsonDecode(response.body);

                        if (responseData['success'] == true || responseData['exists'] == true) {
                          final conversation = Conversation(
                            conversationId: responseData['conversation_id'].toString(),
                            customerId: widget.user.Customer_ID,
                            ownerId: widget.booking.ownerId,
                            customerName: widget.user.Customer_Name,
                            ownerName: widget.booking.ownerName,
                            title: '${widget.booking.ownerName}',
                          );

                          Get.to(() => ConversationDetailsScreen(
                            conversation: conversation,
                            user: widget.user,
                            userType: 'customer',
                          ));
                        } else {
                          throw Exception(responseData['error'] ?? 'Failed to create conversation');
                        }
                      } else {
                        throw Exception('Failed with status code: ${response.statusCode}');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Could not start conversation: $e');
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            buildInfoBox(title: 'Request Date', content: '${booking.requestDate}'),
            buildInfoBox(title: 'Total Amount', content: '${booking.totalPrice}'),
            buildInfoBox(title: 'Start Date', content: '${booking.preferredStartDate}'),
            buildInfoBox(title: 'End Date', content: '${booking.preferredEndDate}'),
            buildInfoBox(title: 'Request Status', content: '${booking.requestStatus}'),
            buildInfoBox(
                title: 'Payment Status',
                content: '${booking.paymentStatus}'
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: hasReviewed
                  ? null // disables button if already reviewed
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewSection(
                      user: widget.user,
                      booking: widget.booking,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hasReviewed ? Colors.grey : Colors.yellow[900],
                fixedSize: Size(410, 55),
              ),
              child: Text(
                hasReviewed ? 'Already Rated' : 'Rate',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
