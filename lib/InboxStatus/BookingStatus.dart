import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:iconsax/iconsax.dart';


class OnGoingStatus extends StatefulWidget {
  final BookingDetails booking;
  final LoggedInUser user;

  const OnGoingStatus({super.key, required this.booking, required this
      .user});

  @override
  State<OnGoingStatus> createState() => _BookingDetailsPage();
}

class _BookingDetailsPage extends State<OnGoingStatus>{

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
