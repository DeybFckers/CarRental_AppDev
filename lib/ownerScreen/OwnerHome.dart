import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:CarRentals/api_connection/cars.dart';
import 'package:CarRentals/pages/add_car.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class OwnerHome extends StatefulWidget {
  final LoggedInOwner owneruser;
  const OwnerHome({super.key, required this.owneruser});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  List<Car> ownerCars = [];

  Future<void> fetchOwnerCars() async {
    try {
      final response = await http.get(Uri.parse(API.getcars));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Car> allCars = data.map((car) => Car.fromJson(car)).toList();

        // Filter by owner email or ID (adjust based on your data structure)
        final List<Car> filtered = allCars.where((car) =>
        car.ownerId == widget.owneruser.Owner_ID).toList();

        setState(() {
          ownerCars = filtered;
        });
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOwnerCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Car'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => AddCar(owneruser: widget.owneruser));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ownerCars.isEmpty
          ? Center(child: Text('No cars found for this owner.'))
          : GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: ownerCars.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final car = ownerCars[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    car.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${car.brand} ${car.model}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '₱${car.dailyRate.toStringAsFixed(2)} / day',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Seats: ${car.seatCapacity}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
