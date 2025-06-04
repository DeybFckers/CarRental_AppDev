import 'package:flutter/material.dart';
import 'package:CarRentals/screens/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';



class BookingSuccessScreen extends StatelessWidget {
  final LoggedInUser user;
  const BookingSuccessScreen({super.key, required this.user});

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
              Text('Thank you for Booking, Have a Safe Trip!',
                style: TextStyle( fontSize: 30.0,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => NavigationMenu(user: user)),
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
