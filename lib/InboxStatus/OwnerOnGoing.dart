import 'package:CarRentals/successScreens/OwnerDoneSuccess.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:http/http.dart' as http;
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/api_connection/completeRental.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/Details/ConversationDetails.dart';
import 'package:CarRentals/api_connection/conversation.dart';


class OwnerOnGoing extends StatefulWidget {
  final LoggedInOwner owneruser;
  final BookingDetails booking;

  const OwnerOnGoing({super.key, required this.owneruser, required
  this.booking});

  @override
  State<OwnerOnGoing> createState() => _OwnerOnGoingState();
}

class _OwnerOnGoingState extends State<OwnerOnGoing> {

  Future<void> completedBooking() async{
    final booking = widget.booking;

    DateTime startDate = DateTime.parse(booking.preferredStartDate);
    DateTime endDate = DateTime.parse(booking.preferredEndDate);
    int days = endDate.difference(startDate).inDays + 1;

    double totalPrice = booking.dailyRate * days;

    RentalComplete rentalComplete = RentalComplete(
      rentalID: booking.rentalID,
      customerID: booking.customerID,
      carID: booking.carId,
      startDate: booking.preferredStartDate,
      endDate: booking.preferredEndDate,
      totalPrice: totalPrice,
      rentalStatus: "Completed",
    );

    try{
      var res = await http.post(
        Uri.parse(API.completedRental),
        body: rentalComplete.toJson(),
      );
      if(res.statusCode == 200){
        var resBodyOfCancel = jsonDecode(res.body);
        if(resBodyOfCancel['Success'] == true){
          Get.off(() => OwnerDoneSuccess(owneruser: widget.owneruser,
              booking: booking));
        } else {

        }
      }
    }catch(e){

    }

  }


  @override
  Widget build(BuildContext context) {

    final booking = widget.booking;
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
                        'customer_id': widget.booking.customerID.toString(),
                        'owner_id': widget.owneruser.Owner_ID.toString(),
                      },
                    );

                    if (response.statusCode == 200) {
                      final responseData = jsonDecode(response.body);

                      if (responseData['success'] == true || responseData['exists'] == true) {
                        final conversation = Conversation(
                          conversationId: responseData['conversation_id'].toString(),
                          customerId: widget.booking.customerID,
                          ownerId: widget.owneruser.Owner_ID,
                          customerName: widget.booking.customerName,
                          ownerName: widget.owneruser.Owner_Name,
                          title: '${widget.booking.customerName}',
                        );

                        Get.to(() => ConversationDetailsScreen(
                          conversation: conversation,
                          user: widget.owneruser,
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
                content: '${booking.requestStatus}'
            ),
            buildInfoBox(
                title: 'Payment Status',
                content: '${booking.paymentStatus}'
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  completedBooking();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[900],
                  fixedSize: Size(410, 55),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                )
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
