import 'package:CarRentals/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
            Text('Your account successfully created!',
              style: TextStyle( fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: () => Get.to(() => LoginPage()),
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
