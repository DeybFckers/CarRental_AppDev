import 'package:CarRentals/screens/BookingStatusScreen.dart';
import 'package:CarRentals/screens/home.dart';
import 'package:CarRentals/screens/Messages.dart';  // make sure this matches your file name
import 'package:CarRentals/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/LoggedInUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationMenu extends StatelessWidget {
  final LoggedInUser user;
  const NavigationMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(user));
    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(FontAwesomeIcons.fileInvoice), label: 'Booking Status'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'Inbox'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final LoggedInUser user;

  NavigationController(this.user);

  late final screens = [
    HomeScreen(user: user),
    BookingStatusScreen(user: user),
    //MessageScreen(user: user), // Pass user here
    ProfileScreen(user: user),

  ];
}