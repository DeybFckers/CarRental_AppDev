import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OwnerInbox extends StatelessWidget {
  final LoggedInUser user;
  final LoggedInOwner owneruser;
  const OwnerInbox({super.key, required this.owneruser, required this.user});

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
        title: const Text(
          'Inbox',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationCard(
            icon: Icons.directions_car,
            title: 'Booking Confirmed',
            message: 'You successfully booked a car!',
            time: 'Just now',
          ),
          // Add more NotificationCard widgets here if needed
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.yellow[800],
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}