  import 'package:CarRentals/api_connection/api_connection.dart';
  import 'package:flutter/material.dart';
  import 'package:CarRentals/api_connection/LoggedInUser.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:CarRentals/api_connection/cars.dart';

  class ReviewDetails extends StatelessWidget {
    final LoggedInUser user;
    final Car car;
    const ReviewDetails({super.key, required this.user, required this.car});

    Future<List<Map<String, dynamic>>> fetchReviews() async {
      final response = await http.post(
        Uri.parse(API.getReview),
        body: {
          "Car_ID": car.carId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Failed to fetch reviews");
      }
    }

    Widget buildStars(int rating) {
      return Row(
        children: List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('${car.brand} ${car.model} Reviews')),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchReviews(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final reviews = snapshot.data!;
            if (reviews.isEmpty) {
              return const Center(child: Text('No reviews for this car yet.'));
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car.brand} ${car.model}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final r = reviews[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Name: ${r["Customer_Name"]}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text('Review and Rating:', style: TextStyle
                                  (fontSize: 15)),
                                buildStars(int.parse(r['Rating'].toString())),
                                if (r['Comment'] != null && r['Comment'].toString().trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      '"${r["Comment"]}"',
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  'Reviewed on: ${r["ReviewDate"]}',
                                  style: const TextStyle(fontSize: 14, color:
                                  Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
