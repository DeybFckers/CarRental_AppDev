import 'package:CarRentals/api_connection/LoggedInOwner.dart';
import 'package:CarRentals/consts/ReuseableClass.dart';
import 'package:CarRentals/successScreens/AddCarSuccess.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:CarRentals/api_connection/api_connection.dart';

class AddCar extends StatefulWidget {
  final LoggedInOwner owneruser;
  const AddCar({super.key, required this.owneruser});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final platenumberController = TextEditingController();
  final dailyrateController = TextEditingController();
  final seatcapacityController = TextEditingController();
  final filenameController = TextEditingController();

  PlatformFile? pickedFile;
  final formKey = GlobalKey<FormState>();

  Future selectFile() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result == null) return;

      setState(() {
        pickedFile = result.files.first;
        filenameController.text = pickedFile!.name;
      });
    } else {
      Fluttertoast.showToast(msg: "Storage permission is required to pick files");
    }
  }

  Future<void> uploadCar() async {
    if (formKey.currentState!.validate() && pickedFile != null) {
      final uri = Uri.parse(API.addcars);

      var request = http.MultipartRequest('POST', uri);
      request.fields['Brand'] = brandController.text;
      request.fields['Model'] = modelController.text;
      request.fields['PlateNumber'] = platenumberController.text;
      request.fields['DailyRate'] = dailyrateController.text;
      request.fields['SeatCapacity'] = seatcapacityController.text;
      request.fields['Owner_ID'] = widget.owneruser.Owner_ID.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          'car_image',
          pickedFile!.path!,
          filename: basename(pickedFile!.path!),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Car added successfully!");
        Get.off(() => AddCarSuccess(owneruser: widget.owneruser));
      } else {
        Fluttertoast.showToast(msg: "Failed to add car.");
      }
    } else {
      Fluttertoast.showToast(msg: "Please complete all fields and pick an image");
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    platenumberController.dispose();
    dailyrateController.dispose();
    seatcapacityController.dispose();
    filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Add a car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details of your car',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                AuthField(hintText: 'Brand', controller: brandController),
                SizedBox(height: 20),
                AuthField(hintText: 'Model', controller: modelController),
                SizedBox(height: 20),
                AuthField(hintText: 'Plate Number', controller: platenumberController),
                SizedBox(height: 20),
                AuthField(hintText: 'Daily Rate', controller: dailyrateController),
                SizedBox(height: 20),
                AuthField(hintText: 'Seat Capacity', controller: seatcapacityController),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: filenameController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'File name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: selectFile,
                      child: Text('Upload File'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: uploadCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[900],
                    fixedSize: Size(410, 55),
                  ),
                  child: Text(
                    'Add a car',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
