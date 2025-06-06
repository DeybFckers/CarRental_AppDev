import 'package:CarRentals/Details/BookingDetailsPage.dart';
import 'package:CarRentals/Details/BookingStatus.dart';
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

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingTab(user: user),
            OnGoingTab(user: user),
            CompletedTab(user: user),
            CancelledTab(user: user)
          ],
        ),
      ),
    );
  }
}

//PendingStatus
class PendingTab extends StatelessWidget{
  final LoggedInUser user;
  const PendingTab({super.key, required this.user});

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

//OnGoing Status
class OnGoingTab extends StatelessWidget{
  final LoggedInUser user;
  const OnGoingTab({super.key, required this.user});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.customerName == user.Customer_Name &&
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
                          builder: (_) => OnGoingStatus(booking: booking,
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

//CompletedStatus
class CompletedTab extends StatelessWidget{
  final LoggedInUser user;
  const CompletedTab({super.key, required this.user});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.customerName == user.Customer_Name &&
          booking.rentalStatus == 'Completed')
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
                          builder: (_) => OnGoingStatus(booking: booking,
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

//cancelledstatus
class CancelledTab extends StatelessWidget{
  final LoggedInUser user;
  const CancelledTab({super.key, required this.user});

  Future<List<BookingDetails>> fetchBookings() async{
    final response = await http.get(Uri.parse(API.getbookingdetails));

    if(response.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item)=>BookingDetails.fromJson(item))
          .where((booking) => booking.customerName == user.Customer_Name &&
          booking.rentalStatus == 'Cancelled')
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
                          builder: (_) => OnGoingStatus(booking: booking,
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



