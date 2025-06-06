import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:iconsax/iconsax.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';


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
                onPressed: () {
                  // message logic here
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

