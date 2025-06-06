import 'package:CarRentals/Details/OwnerBookingDetails.dart';
import 'package:CarRentals/Details/OwnerOnGoing.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class OwnerInbox extends StatelessWidget {
  final LoggedInOwner owneruser;
  const OwnerInbox({super.key, required this.owneruser});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Ongoing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingTab(owneruser: owneruser),
            OnGoingTab(owneruser: owneruser),
          ],
        ),
      ),
    );
  }
}

//PendingStatus
class PendingTab extends StatelessWidget{
  final LoggedInOwner owneruser;
  const PendingTab({super.key, required this.owneruser});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.ownerName == owneruser.Owner_Name &&
          booking.requestStatus == 'Pending')
          .toList();
    }else{
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
        )
    );
  }
}

//OnGoing Status
class OnGoingTab extends StatelessWidget{
  final LoggedInOwner owneruser;
  const OnGoingTab({super.key, required this.owneruser});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.ownerName == owneruser.Owner_Name &&
          booking.rentalStatus == 'Confirmed')
          .toList();
    }else{
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          builder: (_) => OwnerOnGoing(booking: booking,
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
                        trailing: Text(booking.rentalStatus,
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