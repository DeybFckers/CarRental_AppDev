import 'package:CarRentals/pages/login_page.dart';
import 'package:CarRentals/successScreens/Registration_success.dart';
import 'package:CarRentals/api_connection/RegistrationUser.dart';
import 'package:flutter/material.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:CarRentals/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  static route () =>  MaterialPageRoute(
    builder: (context) => const SignupPage(),
  );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  validateUserEmail()async
  {
    try{
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'Customer_Email': emailController.text.trim(),
        },
      );

      if(res.statusCode == 200){
        var resBodyOfValidateEmail =jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound'] == true){
          Fluttertoast.showToast(msg: "Email is already in someone else use. "
              "Try another email.");
        }
        else{
          registerAndSaveUserRecord();
        }
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error validating email.");
    }
  }

  registerAndSaveUserRecord() async {
    RegistrationUser userModel = RegistrationUser(
      nameController.text.trim(),
      addressController.text.trim(),
      contactController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try{
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      if(res.statusCode == 200){
        var resBodyOfSignUp = jsonDecode(res.body);
        if(resBodyOfSignUp['Success'] == true){
          Get.off(() => SuccessScreen());
        }
        else{
          Fluttertoast.showToast(msg: "Error Occured, Try Again.");
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    nameController.dispose();
    contactController.dispose();
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
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text ('Create your Account',
                  style: TextStyle(fontSize: 45,
                  fontWeight: FontWeight.bold,

                    ),
                  ),
                  SizedBox(height: 20,),
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  SizedBox(height: 20,),
                  AuthField(
                    hintText: 'Address',
                    controller: addressController,
                  ),
                  SizedBox(height: 20,),
                  AuthField(
                    hintText: 'Contacts',
                    controller: contactController,
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
              ElevatedButton(
                onPressed: () {
                  if(formKey.currentState!.validate())
                    {
                      //validate the email
                      validateUserEmail();

                    }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[900],
                  fixedSize: Size(410, 55),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, LoginPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                          text: ("Already have an account? "),
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
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
      )
    );
  }
}
