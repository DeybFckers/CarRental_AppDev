import 'package:flutter/material.dart';
import 'package:CarRentals/colors/app_pallete.dart';


class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPasswordText;
  final IconData? icon;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPasswordText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefix: icon !=null ? Icon(icon, color: Colors.grey[700]) : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$hintText is missing!";
        }

        if (hintText == "Email") {
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) {
            return "Enter a valid email address";
          }
        }

        if (hintText == "Contacts") {
          final digitsOnly = RegExp(r'^\d+$');
          if (!digitsOnly.hasMatch(value)) {
            return "Enter your valid contact number";
          }
        }

        return null;
      },
      obscureText: isPasswordText,
    );
  }
}

Widget buildInfoBox({
  required String title,
  required String content,
  Widget? trailing,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppPallete.gradient2,
        width: 1.5,
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (trailing != null) trailing,
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 18,
            color: AppPallete.BodyText,
          ),
        ),
      ],
    ),
  );
}


