import 'dart:convert';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/api_connection/getRental.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/successScreens/Cancel_success.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:get/get.dart';

class OnGoingStatus extends StatefulWidget {
  final BookingDetails booking;
  final LoggedInUser user;

  const OnGoingStatus({super.key, required this.booking, required this
      .user});

  @override
  State<OnGoingStatus> createState() => _BookingDetailsPage();
}

class _BookingDetailsPage extends State<OnGoingStatus>{
  Future<void> cancelBooking() async{
    final booking = widget.booking;

    DateTime startDate = DateTime.parse(booking.preferredStartDate);
    DateTime endDate = DateTime.parse(booking.preferredEndDate);
    int days = endDate.difference(startDate).inDays + 1;

    double totalPrice = booking.dailyRate * days;

    RentalCancel rentalCancel = RentalCancel(
      customerID: widget.user.Customer_ID,
      carID: booking.carId,
      startDate: booking.preferredStartDate,
      endDate: booking.preferredEndDate,
      totalPrice: totalPrice,
      rentalStatus: "Cancelled",
    );

    try{
      var res = await http.post(
        Uri.parse(API.cancelRental),
        body: rentalCancel.toJson(),
      );
      if(res.statusCode == 200){
        var resBodyOfCancel = jsonDecode(res.body);
        if(resBodyOfCancel['Success'] == true){
          Get.off(() => CancelSuccessScreen(user: widget.user));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size:20, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      '${booking.ownerName}',
                      style: TextStyle(fontSize: 20, color: Colors.white,),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Iconsax.message, color: Colors.white),
                  onPressed: () {

                  },
                )
              ],
            ),
            SizedBox(height: 10),
            buildInfoBox(
                title: 'Request Date',
                content: '${booking.requestDate}'
            ),
            buildInfoBox(
                title: 'Total Amount',
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
