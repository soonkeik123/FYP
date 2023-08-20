import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/pet/edit_pet.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/info_text.dart';

class ViewPetPage extends StatefulWidget {
  static const routeName = '/viewPet';
  final String petId;
  const ViewPetPage({
    super.key,
    required this.petId,
  });

  @override
  State<ViewPetPage> createState() => _ViewPetPageState();
}

class _ViewPetPageState extends State<ViewPetPage> {
  final List<Map> petDataList = [];
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  // Pet info
  String petName = '';
  String petGender = '';
  String petType = '';
  String petSize = '';
  String petBreed = '';
  String petBirthday = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      dbPetRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(uid)
          .child('Pet');
    }
    getPetById(widget.petId);
  }

  // Get a specific pet by name
  Future<void> getPetById(String petID) async {
    final snapshot = await dbPetRef.child(petID).get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;
      if (petData.isNotEmpty) {
        String name = petData['name'];
        String gender = petData['gender'];
        String breed = petData['breed'];
        String size = petData['size'];
        String birthday = petData['birthday'];
        String type = petData['type'];
        String image = petData['imageUrl'];

        setState(() {
          petName = name;
          petGender = gender;
          petBreed = breed;
          petSize = size;
          petBirthday = birthday;
          petType = type;
          imageUrl = image;
        });
      } else {
        print("Loading error, unnecessary if else.");
      }
    } else {
      print("Pet not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          // Header
          CustomHeader(
            pageTitle: petName,
          ),

          Stack(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 1.6,
                margin: const EdgeInsets.only(top: 110, bottom: 50),
              ),
              Container(
                child: Column(
                  children: [
                    if (imageUrl.isEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        height: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: petType == 'Dog'
                                    ? const AssetImage("assets/images/dog.jpeg")
                                    : const AssetImage(
                                        "assets/images/cat.jpg"))),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(imageUrl)),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          const Text(
                            "Profile",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w300),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPetProfile(
                                            petId: widget.petId,
                                          )));
                            },
                            child: const Icon(
                              Icons.edit_document,
                              size: 30,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                InfoText(
                                  text: petGender,
                                  normal: false,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Pet Type",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                InfoText(
                                  text: petType,
                                  normal: false,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Breed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 160,
                                  child: Text(
                                    petBreed,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Size",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                InfoText(
                                  text: petSize,
                                  normal: false,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 140,
                                  child: Text(
                                    "Birthday",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                InfoText(
                                  text: petBirthday,
                                  normal: false,
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Positioned(
                  bottom: 40,
                  left: 5,
                  child: SizedBox(
                    height: 150,
                    child: Image.asset("assets/images/cute-image-1.png"),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
