import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/pet/edit_pet.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/info_text.dart';

class ViewPetPage extends StatefulWidget {
  static const routeName = '/viewPet';
  final String petName;
  const ViewPetPage({
    super.key,
    required this.petName,
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
    getPetByName(widget.petName);
  }

  // Get a specific pet by name
  void getPetByName(String petName) {
    // // Query to filter pets by name
    // Query petQuery =
    //     dbPetRef.orderByChild('name').equalTo(petName);
    // // Real-time event listener
    // petQuery.onValue.listen((event) {
    //   DataSnapshot snapshot = event.snapshot;
    //   if (snapshot.value != null) {
    //     // Convert the snapshot value to a Map
    //     Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;

    //     // Iterate through the Map to get individual pet data
    //     petData.forEach((key, value) {
    //       print('Pet with key $key has data: $value');

    //       // Access individual properties of the pet
    //       String name = value['name'];
    //       String gender = value['gender'];
    //       String breed = value['breed'];
    //       String size = value['size'];
    //       String birthday = value['birthday'];
    //       String type = value['type'];

    //       // Do something with the pet data
    //       setState(() {
    //         petName = name;
    //         petBreed = breed;
    //         petGender = gender;
    //         petSize = size;
    //         petBirthday = birthday;
    //         petType = type;
    //       });
    //       print("Been Here");
    //     });
    //   } else {
    //     // No pet with the specified name found
    //     print('No pet with name $petName found.');
    //   }
    // }, onError: (error) {
    //   // Error retrieving data from the database
    //   print('Error fetching pet data: $error');
    // });
    dbPetRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        // petDataList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<dynamic, dynamic> petData =
              Map.from(value['data']); // Access the inner map
          petData['key'] = key;
          refreshItems(petData);
        });
      }
    });
  }

  void refreshItems(Map pet) {
    setState(() {
      // Simulate a data refresh by adding a new item to the list
      petDataList.add(pet);
      print(petDataList);

      // petName = specificPet['name'];
      // petGender = specificPet['gender'];
      // petBreed = specificPet['breed'];
      // petType = specificPet['type'];
      // petSize = specificPet['size'];
      // petBirthday = specificPet['birthday'];
    });
    // Find the first pet with the matching name in the petDataList
    List<Map<String, dynamic>> matchingPets = [];

    // Find all pets with the matching name in the petDataList
    // Find all pets with the matching name in the petDataList
    for (var pet in petDataList) {
      if (pet['name'] == widget.petName) {
        matchingPets.add(Map<String, dynamic>.from(pet));
      }
    }
    if (matchingPets.isNotEmpty) {
      // Get data from the matching pets
      for (var pet in matchingPets) {
        String name = pet['name'];
        String gender = pet['gender'];
        String breed = pet['breed'];
        String size = pet['size'];
        String birthday = pet['birthday'];
        String type = pet['type'];

        // Do something with the pet data (you can use the data as needed)
        setState(() {
          petName = name;
          petBreed = breed;
          petType = type;
          petSize = size;
          petGender = gender;
          petBirthday = birthday;
        });
      }
    } else {
      // No pet with the specified name found
      print('No pet with name $petName found.');
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
            pageTitle: widget.petName,
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
                    InkWell(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        height: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: petType == 'Dog'
                                    ? const AssetImage("assets/images/dog.jpeg")
                                    : const AssetImage("assets/images/cat.jpg"))),
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
                                            petName: petName,
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
                                InfoText(
                                  text: petBreed,
                                  normal: false,
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
