import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/ownerScreen/OwnerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';

class OwnerCancelSuccess extends StatelessWidget {
  final LoggedInOwner owneruser;
  final BookingDetails booking;
  const OwnerCancelSuccess({super.key, required this.owneruser, required this
      .booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset('images/QuickViewLogo.png', width: 300),
              SizedBox(height: 40.0),
              Text('You Cancelled the booked of ${booking.customerName}',
                style: TextStyle( fontSize: 30.0,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(onPressed: () => Get.to(() =>
                    OwnerNavigation(owneruser: owneruser)),
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[900],
                      fixedSize: Size(410, 55)
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
