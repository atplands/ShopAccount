import 'dart:io';

import 'package:account/global/global.dart';
import 'package:account/mainScreens/home_screen.dart';
import 'package:account/model/customers.dart';
import 'package:account/model/suppliers.dart';
import 'package:account/widgets/custom_text_field.dart';
import 'package:account/widgets/error_dialog.dart';
import 'package:account/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerEditScreen extends StatefulWidget {
  Customers? model;
  BuildContext? context;
  CustomerEditScreen({this.model, this.context});
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController imageController = TextEditingController();
  TextEditingController custNameController = TextEditingController();
  TextEditingController custInfoController = TextEditingController();
  TextEditingController custContactController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  //nameController = sharedPreferences!.getString("name")!;
  final ImagePicker _picker = ImagePicker();

  //nameController = sharedPreferences!.getString("name")!;

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      imageController.text = sharedPreferences!.getString("photoUrl")!;
      custNameController.text = sharedPreferences!.getString("name")!;
      custInfoController.text = sharedPreferences!.getString("email")!;
      custContactController.text = sharedPreferences!.getString("pwd")!;
      locationController.text = sharedPreferences!.getString("address")!;
    });
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placeMarks![0];

    String completeAddress =
        ' ${pMark.subThoroughfare} ${pMark.thoroughfare} , ${pMark.subLocality}  ${pMark.locality} , ${pMark.subAdministrativeArea} , ${pMark.administrativeArea}  ${pMark.postalCode} , ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (custNameController.text.isNotEmpty &&
        custInfoController.text.isNotEmpty &&
        custContactController.text.isNotEmpty &&
        locationController.text.isNotEmpty) {
      //start uploading image
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Registering Account",
            );
          });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child("shops")
          .child(fileName);
      if (imageXFile == null) {
        sellerImageUrl = sharedPreferences!.getString("photoUrl")!;
      } else {
        fStorage.UploadTask uploadTask =
            reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerImageUrl = url;
        });
      }
      //save info to firestore
      saveDataToFirestore().then(
        (value) {
          print('Profile Updated ');
          Navigator.pop(context);
          //send user to homePage
          Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        },
      );
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message:
                  "Please write the complete required info for Registration.",
            );
          });
    }
  }

  Future saveDataToFirestore() async {
    FirebaseFirestore.instance
        .collection("shops")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      //"sellerUID": currentUser.uid,
      "shopName": custNameController.text.trim(),
      "shopAvatarUrl": sellerImageUrl,
      "phone": custContactController.text.trim(),
      "aboutUs": custInfoController.text.trim(),
      "address": locationController.text.trim(),
      //"status": "approved",
      //"earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    print('Profile Data Updated into Firebase');

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    //await sharedPreferences!.setString("uid", currentUser.uid);]
    /*await sharedPreferences!.setString("email", nameController.text.trim());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("pwd", passwordController.text.trim());
    await sharedPreferences!.setString("phone", phoneController.text.trim());
    await sharedPreferences!
        .setString("aboutUs", aboutUsController.text.trim());
    await sharedPreferences!
        .setString("address", locationController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        automaticallyImplyLeading: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: "Lobster",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      NetworkImage(sharedPreferences!.getString("photoUrl")!),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.greenAccent,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        data: Icons.person,
                        controller: custNameController,
                        hintText: "Name",
                        isObsecre: false,
                      ),
                    ),
                    CustomTextField(
                      data: Icons.phone,
                      controller: custContactController,
                      hintText: "Phone",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.book_rounded,
                      controller: custInfoController,
                      hintText: "AboutShop",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.my_location,
                      controller: locationController,
                      hintText: "Shop Address",
                      isObsecre: false,
                      enabled: true,
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        label: const Text(
                          "Get my Current Location",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          getCurrentLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text(
                  "Update Customer",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: () {
                  formValidation();
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
