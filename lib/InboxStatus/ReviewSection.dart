import 'package:CarRentals/api_connection/BookingDetails.dart';
import 'package:CarRentals/successScreens/ReviewSuccess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/api_connection.dart'; // adjust if needed
import 'package:CarRentals/api_connection/LoggedInUser.dart';

class ReviewSection extends StatefulWidget {
  final LoggedInUser user;
  final BookingDetails booking;

  const ReviewSection({super.key, required this.user, required this.booking});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  bool isLoading = false;

  Future<void> submitReview() async {
    if (_rating == 0 || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please give a rating and a comment")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var res = await http.post(
        Uri.parse(API.submitReview), // Define this in your API constants
          body: {
            "Customer_ID": widget.user.Customer_ID.toString(),
            "Car_ID": widget.booking.carId.toString(),
            "Rating": _rating.toInt().toString(),
            "Comment": _commentController.text,
          }
      );

      var data = jsonDecode(res.body);
      if (data['Success'] == true) {
        Get.off(() => ReviewSuccess(user: widget.user));
        _commentController.clear();
        setState(() => _rating = 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit review")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Write a Review")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Rate Your Experience",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Write your comment",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                submitReview();
              },
              icon: Icon(Icons.send),
              label: Text("Submit Review",
              style: TextStyle(fontSize: 20, color: Colors.white)
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[900],
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
