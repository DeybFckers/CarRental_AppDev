import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:CarRentals/ownerScreen/OwnerNavigation.dart';
import 'package:CarRentals/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/pages/signup_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';




class LoginPage extends StatefulWidget {
  static route () =>  MaterialPageRoute(
    builder: (context) => const LoginPage(),
  );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedUserType = 'Customer';

  loginUserNow() async {
    var res = await http.post(
      Uri.parse(API.login),
      body: {
        "Customer_Email": emailController.text.trim(),
        "Customer_Password": passwordController.text.trim(),
      }
    );
    if(res.statusCode == 200){
      var resBodyOfLogin = jsonDecode(res.body);
      if(resBodyOfLogin['Success'] == true){
        LoggedInUser loggedinUser = LoggedInUser.fromJson(resBodyOfLogin["userData"]);

        Get.off(() => NavigationMenu(user: loggedinUser));
      }
      else{
        Fluttertoast.showToast(msg: "Incorrect Credentials. Please write correct password or email, Try Again.");
      }
    }
  }

  loginOwnerNow() async {
    var res = await http.post(
        Uri.parse(API.Ownerlogin),
        body: {
          "Owner_Email": emailController.text.trim(),
          "Owner_Password": passwordController.text.trim(),
        }
    );
    if(res.statusCode == 200){
      var resBodyOfOwnerLogin = jsonDecode(res.body);
      if(resBodyOfOwnerLogin['Success'] == true){
        LoggedInOwner loggedinOwner = LoggedInOwner.fromJson
          (resBodyOfOwnerLogin["userData"]);

        Get.off(() => OwnerNavigation(owneruser: loggedinOwner));
      }
      else{
        Fluttertoast.showToast(msg: "Incorrect Credentials. Please write correct password or email, Try Again.");
      }
    }
  }

  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to your Account',
                    style: TextStyle(fontSize: 50,
                    fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20,),
                  AuthField(
                      hintText: 'Email',
                      controller: emailController,
                  ),
                  SizedBox(height: 20,),
                  AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      isPasswordText: true,
                  ),
                  SizedBox(height: 20,),
                  DropdownButton<String>(
                    value: selectedUserType,
                    items: ['Customer', 'Owner'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedUserType = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (selectedUserType == 'Customer') {
                          loginUserNow();
                        } else {
                          loginOwnerNow();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[900],
                        fixedSize: Size(410, 55)),
                    child: Text('Sign In',
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, SignupPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: ("Don\'t have an account? "),
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                  text: 'Sign Up',
                                  style:Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.yellow[900],
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                            ]
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
