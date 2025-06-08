import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:iconsax/iconsax.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/Details/ConversationDetails.dart';
import 'package:CarRentals/api_connection/conversation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/api_connection.dart';

class OwnerStatus extends StatelessWidget {
  final LoggedInOwner owneruser;
  final BookingDetails booking;
  const OwnerStatus({super.key, required this.booking, required this
      .owneruser});

  @override
  Widget build(BuildContext context) {

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
            buildInfoBox(
              title: 'Customer Name',
              content: '${booking.customerName}',
              trailing: IconButton(
                icon: Icon(Iconsax.message, color: Colors.white),
                onPressed: () async {
                  try {
                    final response = await http.post(
                      Uri.parse(API.createConversation),
                      body: {
                        'customer_id': booking.customerID.toString(),
                        'owner_id': owneruser.Owner_ID.toString(),
                      },
                    );

                    if (response.statusCode == 200) {
                      final responseData = jsonDecode(response.body);

                      if (responseData['success'] == true || responseData['exists'] == true) {
                        final conversation = Conversation(
                          conversationId: responseData['conversation_id'].toString(),
                          customerId: booking.customerID,
                          ownerId: owneruser.Owner_ID,
                          customerName: booking.customerName,
                          ownerName: owneruser.Owner_Name,
                          title: '${booking.customerName}',
                        );

                        Get.to(() => ConversationDetailsScreen(
                          conversation: conversation,
                          user: owneruser,
                          userType: 'owner',
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
              ),
            ),
            buildInfoBox(
                title: 'Request Date',
                content: '${booking.requestDate}'
            ),
            buildInfoBox(
                title: 'Price',
                content: '${booking.totalPrice}'
            ),
            buildInfoBox(
                title: 'Start Date',
                content: '${booking.preferredStartDate}'
            ),
            buildInfoBox(
                title: 'End Date',
                content: '${booking.preferredEndDate}'
            ),
            buildInfoBox(
                title: 'Request Status',
                content: '${booking.rentalStatus}'
            ),
            buildInfoBox(
                title: 'Payment Status',
                content: '${booking.paymentStatus}'
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

