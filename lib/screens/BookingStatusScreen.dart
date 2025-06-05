import 'package:CarRentals/Details/BookingDetailsPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/screens/navigation_menu.dart';
import 'package:get/get.dart';



class BookingStatusScreen extends StatelessWidget {
  final LoggedInUser user;
  const BookingStatusScreen({super.key, required this.user});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.customerName == user.Customer_Name &&
                              booking.requestStatus == 'Pending')
          .toList();
    }else{
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<BookingDetails>>(
          future: fetchBookings(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final bookings =snapshot.data!;
            if (bookings.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Bookings found.',
                      style: TextStyle(fontSize: 20, color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        final controller = Get.find<NavigationController>();
                        controller.selectedIndex.value = 0;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[900],
                        fixedSize: Size(300, 55)
                      ),
                      child: Text('Book a car',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white)
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailsPage(booking: booking,
                            user: user),
                      ),
                    );
                  },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('${booking.brand} ${booking.model}',
                          style: TextStyle(color: Colors.white, fontWeight:
                          FontWeight.bold),
                        ),
                        subtitle: Text(
                          'From ${booking.preferredStartDate} to ${booking
                              .preferredEndDate}',
                        ),
                        trailing: Text(booking.requestStatus,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    )
                );
              },
            );
          },
        )
    );
  }
}