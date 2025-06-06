import 'package:CarRentals/Details/OwnerBookingDetails.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class OwnerInbox extends StatelessWidget {
  final LoggedInOwner owneruser;

  const OwnerInbox({super.key, required this.owneruser});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));
    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.customerName.isNotEmpty &&
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
        title: const Text('Inbox', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0),
      body: FutureBuilder<List<BookingDetails>>(
        future: fetchBookings(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError){

          }

          final bookings = snapshot.data!;
          if(bookings.isEmpty){
            return Center (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Bookings Found.',
                style: TextStyle(fontSize: 20, color: Colors.white
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index){
              final booking = bookings[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerBookingDetails(booking: booking,
                          owneruser: owneruser),
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

      ),
    );
  }
}