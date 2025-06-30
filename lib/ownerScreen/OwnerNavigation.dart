import 'package:CarRentals/ownerScreen/OwnerInbox.dart';
import 'package:CarRentals/ownerScreen/OwnerProfile.dart';
import 'package:CarRentals/ownerScreen/OwnerMessages.dart';
import 'package:CarRentals/ownerScreen/OwnerHome.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:CarRentals/api_connection/LoggedInOwner.dart';



class OwnerNavigation extends StatelessWidget {
  final LoggedInOwner owneruser;

  const OwnerNavigation({super.key, required this.owneruser});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OwnerNavigationController(owneruser));
    return Scaffold(
      bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value
            = index,
            destinations: [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.direct_inbox), label:
              'Inbox'),
              NavigationDestination(icon: Icon(Iconsax.message), label: 'Mess'
                  'ages'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
            ],
          )
      ),
      body: Obx (() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class OwnerNavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  final LoggedInOwner owneruser;


  OwnerNavigationController(this.owneruser);

  late final screens = [OwnerHome(owneruser: owneruser,),OwnerInbox(owneruser:
  owneruser),
    OwnerMessageScreen(owneruser: owneruser),OwnerProfileScreen(owneruser: owneruser)
  ];
}

