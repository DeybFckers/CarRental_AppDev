import 'dart:convert';
import 'package:CarRentals/Details/ConversationDetails.dart';
import 'package:CarRentals/Details/ReviewDetails.dart';
import 'package:CarRentals/successScreens/Booking_success.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/api_connection/cars.dart';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:iconsax/iconsax.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CarRentals/api_connection/bookingrequest.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/api_connection/conversation.dart';

class CarDetailPage extends StatefulWidget {
  final Car car;
  final LoggedInUser user;
  const CarDetailPage({Key? key, required this.car, required this.user,}) :
        super(key: key);

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  String? _selectedPaymentMethod;
  DateTime? preferredStartDate;
  DateTime? preferredEndDate;
  List<DateTime>blockedDates = [];

  @override
  void initState() {
    super.initState();
    fetchBlockedDates();
  }


  fetchBlockedDates() async {
    var res = await http.post(
      Uri.parse(API.carAvailable),
      body: {'Car_Id': widget.car.carId.toString()},
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      // If response is directly a map of index: date
      if (decoded is List) {
        setState(() {
          blockedDates = decoded
              .map<DateTime>((dateStr) => DateTime.parse(dateStr))
              .toList();
        });
      } else {
        print("Unexpected JSON structure: ${res.body}");
      }
    }
  }


  bool isDateBlocked(DateTime day) {
    String dayStr = day.toIso8601String().split('T')[0];
    return blockedDates.any((blockedDay) => blockedDay.toIso8601String()
        .split('T')[0] == dayStr);
  }


  //StartDatePicker Function
  Future<void> pickStartDate() async {
    DateTime today = DateTime.now();
    DateTime initial = preferredStartDate ?? today;

    // find the next available date starting from today
    while (isDateBlocked(initial)) {
      initial = initial.add(Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(2100),
      selectableDayPredicate: (day) => !isDateBlocked(day),
    );

    if (picked != null) {
      setState(() {
        preferredStartDate = picked;
        if (preferredEndDate != null && preferredEndDate!.isBefore(picked)) {
          preferredEndDate = null;
        }
      });
    }
  }

  //EndDatePicker Function
  Future<void>pickEndDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: preferredEndDate ??
            (preferredStartDate ?? DateTime.now()).add(Duration(days: 1)),
        firstDate: preferredStartDate ?? DateTime.now(),
        lastDate: DateTime(2100),
      selectableDayPredicate: (day) {
          if(preferredStartDate == null) return false;
          return !isDateBlocked(day) && !day.isBefore(preferredStartDate!);
      }
    );
    //unclickabledatepicker
    if (picked !=null) {
      setState(() {
        preferredEndDate = picked;
      });
    }
  }


  BookingRequestRecord() async{
    BookingRequest bookingrequestRecord = BookingRequest (
      customerId: widget.user.Customer_ID,
      carId: widget.car.carId,
      preferredStartDate: preferredStartDate!.toIso8601String().split('T')[0],
      preferredEndDate: preferredEndDate!.toIso8601String().split('T')[0],
      paymentMethod: _selectedPaymentMethod!,
    );
    try{
      var res = await http.post(
        Uri.parse(API.getbookingrequest),
        body: bookingrequestRecord.toJson(),
      );
      if(res.statusCode ==200){
        var resBodyOfRequest = jsonDecode(res.body);
        if(resBodyOfRequest['Success'] == true){
          Get.off(() => BookingSuccessScreen(user: widget.user));
        } else{

        }
      }
    }catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(title: Text('${car.brand} ${car.model}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              car.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              '${car.brand} ${car.model}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size:20, color: Colors.grey),
                    SizedBox(width:6),
                    Text(
                        '${car.ownerName}',
                        style: TextStyle(fontSize: 20, color: Colors.white,
                        )
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Iconsax.message, color: Colors.white),
                  onPressed: () async {
                    try {
                      // Create or get existing conversation
                      final response = await http.post(
                        Uri.parse(API.createConversation),
                        body: {
                          'customer_id': widget.user.Customer_ID.toString(),
                          'owner_id': widget.car.ownerId.toString(),
                        },
                      );

                      if (response.statusCode == 200) {
                        final responseData = jsonDecode(response.body);

                        if (responseData['success'] == true || responseData['exists'] == true) {
                          final conversation = Conversation(
                            conversationId: responseData['conversation_id'].toString(),
                            customerId: widget.user.Customer_ID,
                            ownerId: widget.car.ownerId,
                          );

                          Get.to(() => ConversationDetailsScreen(
                            conversation: conversation,
                            user: widget.user,
                            userType: 'customer',
                          ));
                        } else {
                          throw Exception(responseData['error'] ?? 'Failed to create conversation');
                        }
                      } else {
                        throw Exception('Failed with status code: ${response.statusCode}');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Could not start conversation: $e');
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Car Info',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.ac_unit, size: 30, color: Colors.blueGrey),
                    SizedBox(width: 15),
                    Text('Air Conditioner', style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Iconsax.setting, size: 30, color: Colors.blueGrey),
                    SizedBox(width: 15),
                    Text('Manual', style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.carSide,
                        size: 28, color: Colors.blueGrey),
                    SizedBox(width: 15),
                    Text('${car.seatCapacity} seats', style: TextStyle
                      (fontSize: 15)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            buildInfoBox(
              title: 'Rental Inclusion',
              content:
              '• Full tank to Full Tank Policy: Please return the vehicle with the same fuel level as when picked up (Full Tank).\n'
                  '• Clean and sanitized vehicle before every rental.\n'
                  '• 24/7 roadside assistance for emergencies.',
            ),
            buildInfoBox(
              title: 'Requirement',
              content:
              '• Valid Driver\'s License (Local or International)\n'
                  '• Valid Government-issued ID\n'
                  '• Security deposit (refundable upon return)\n'
                  '• Minimum rental period: 1 day',
            ),
            buildInfoBox(
              title: 'Additional Information',
              content:
              '• No smoking inside the vehicle.\n'
                  '• Pets are not allowed unless approved in advance\n'
                  '• Late return fee: ₱200/hour after the agreed time.',
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size:20, color: Colors.grey),
                    SizedBox(width:6),
                    Text(
                        'Rating and Review',
                        style: TextStyle(fontSize: 20, color: Colors.white,
                        )
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Iconsax.arrow_right_1, color: Colors.white),
                  onPressed: (){
                    Get.off(() => ReviewDetails(user: widget.user, car: car));
                  },
                )
              ],
            ),
            Text('₱${car.dailyRate.toStringAsFixed(2)} per day',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            //InlineDatePickButton
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Rental Dates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: pickStartDate,
                  child: Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                          preferredStartDate != null
                              ? 'Start ${preferredStartDate!.toLocal()
                              .toString().split(' ')[0]}'
                              : 'Select Start Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: preferredStartDate != null ? pickEndDate : null,
                  child: Row(
                    children: [
                      Icon(Icons.date_range, color: preferredStartDate != null
                      ? Colors.white
                      : Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        preferredEndDate != null
                            ? 'End: ${preferredEndDate!.toLocal().toString()
                            .split(' ')[0]}'
                            :'Select End Date',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  value: 'Gcash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  title: Text('Gcash'),
                ),
                RadioListTile<String>(
                  value: 'Online Bank',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  title: Text('Online Bank'),
                ),
                RadioListTile<String>(
                  value: 'Personal Cash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  title: Text('Personal Cash'),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: (preferredStartDate != null &&
                    preferredEndDate != null &&
                    _selectedPaymentMethod != null)
                    ? () {
                  BookingRequestRecord();
                }
                    :null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[900],
                ),
                child: const Text(
                  'Rent a Car',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // space below button
          ],
        ),
      ),
    );
  }
}
