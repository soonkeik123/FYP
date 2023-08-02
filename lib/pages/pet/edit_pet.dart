import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';

import '../../widgets/big_text.dart';
import '../../widgets/header.dart';

class EditPetProfile extends StatefulWidget {
  static const routeName = '/editPet';
  final String petName;
  const EditPetProfile({super.key, required this.petName});

  @override
  State<EditPetProfile> createState() => _EditPetProfileState();
}

class _EditPetProfileState extends State<EditPetProfile> {
  final List<Map> petDataList = [];
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  // TextEditingController
  // Name
  final TextEditingController _nameController = TextEditingController();
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  // Gender
  String selectedGender = '';
  // Pet type
  String dropdownValue1 = '';
  String dropdownValue2 = '';

  // Pet Type
  final List<String> petTypes = ['Dog', 'Cat'];

  bool dogSelected = true;
  bool size1 = false;
  bool size2 = false;
  bool size3 = false;
  bool size4 = false;

  // Pet info
  String petName = '';
  String petGender = '';
  String petType = '';
  String petSize = '';
  String petBreed = '';
  String petBirthday = '';

  String selectedSize = '';

  // Dog Breed
  final List<String> dogBreeds = [
    'Labrador',
    'Golden Retriever',
    'Poodle',
    'Bulldog',
    'Silky Terrier',
    'Yolkshy Terrier'
  ];
  final List<String> catBreeds = [
    'Siamese',
    'Persian',
    'Maine Coon',
    'British Shorthair'
  ];

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

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
    setPetProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Get a specific pet by name
  void getPetByName(String petName) {
    dbPetRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        // petDataList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<dynamic, dynamic> petData =
              Map.from(value['data']); // Access the inner map
          petData['key'] = key;
          addPetData(petData);
        });
      }
    });
  }

  void addPetData(Map pet) {
    // Simulate a data refresh by adding a new item to the list
    petDataList.add(pet);

    List<Map<String, dynamic>> matchingPets = [];

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

        // Do something with the pet data
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
    setPetProfile();
  }

  // Shows option when user clicked on profile image
  void _profilePicEdit() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 130, // Set the height of the bottom sheet
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Album'),
                onTap: () {
                  // Handle 'Choose from Album' option
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  // Handle 'Take Photo' option
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSizeSelected() {
    if (size1) {
      setState(() {
        selectedSize = "Small";
      });
    } else if (size2) {
      setState(() {
        selectedSize = "Medium";
      });
    } else if (size3) {
      setState(() {
        selectedSize = "Large";
      });
    } else if (size4) {
      setState(() {
        selectedSize = "Giant";
      });
    } else if (!(size1 && size2 && size3 && size4)) {
      setState(() {
        selectedSize = '';
      });
    }
  }

  // Preset the selection of Pet profile
  void setPetProfile() {
    setState(() {
      // Name
      _nameController.text = petName;
      // Gender
      selectedGender = petGender;
      // Pet Type
      dropdownValue1 = petType;
      if (dropdownValue1 == 'Dog') {
        dogSelected = true;
      } else {
        dogSelected = false;
      }
      // Pet Breed
      dropdownValue2 = petBreed;
      // Size
      if (petSize == 'Small') {
        size1 = !size1;
      } else if (petSize == 'Medium') {
        size2 = !size2;
      } else if (petSize == 'Large') {
        size3 = !size3;
      } else if (petSize == 'Giant') {
        size4 = !size4;
      } else {
        print("No Size");
      }
      // Birthday
      dateInput.text = petBirthday;
    });
  }

  void updatePetByName(String name, Map<String, dynamic> updatedData) {
    // Query to filter pets by name
    Query petQuery = dbPetRef.orderByChild('data/name').equalTo(widget.petName);
    // Real-time event listener to get the pet's key
    petQuery.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;

        // Since there may be multiple pets with the same name, we loop through the results
        petData.forEach((key, value) {
          // Use the key to update the specific pet
          DatabaseReference petRef = dbPetRef.child(key).child('data');
          petRef.update(updatedData).then((_) {
            print('Pet updated successfully!');

            dispose();
          }).catchError((error) {
            print('Error updating pet: $error');
          });
        });
      } else {
        print('No pet with name $name found.');
      }
    }, onError: (error) {
      print('Error fetching pet data: $error');
    });
  }

  void removePet(String name) {
    // Query to filter pets by name
    Query petQuery = dbPetRef.orderByChild('data/name').equalTo(widget.petName);

    // Real-time event listener to get the pet's key
    petQuery.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;

        // Iterate through the Map to find the pet with the specified name
        String petKey = "";
        petData.forEach((key, value) {
          if (value['data']['name'] == widget.petName) {
            petKey = key;
            return;
          }
        });

        // If the pet key is found, remove the pet
        if (petKey.isNotEmpty) {
          // Construct the reference to the specific pet's data
          DatabaseReference petRef = dbPetRef.child(petKey);

          // Call the remove() method on the reference to delete the pet
          petRef.remove().then((_) {
            print(
                "Pet with name $petName and key $petKey removed successfully.");
            showLoadingDialog(context)
                .then((value) => Navigator.popAndPushNamed(context, '/home'));
          }).catchError((error) {
            print(
                "Error removing pet with name $petName and key $petKey: $error");
          });
        } else {
          // No pet with the specified name found
          print("No pet with name $petName found.");
        }
      } else {
        // No pets found
        print("No pets found.");
      }
    }, onError: (error) {
      // Error retrieving data from the database
      print("Error fetching pet data: $error");
    });
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent the dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(), // Loading indicator
                SizedBox(height: 10),
                Text("Loading...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );

    // Delay the dialog dismissal for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Close the dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        const CustomHeader(
          pageTitle: "Edit Pet Profile",
        ),

        // body
        Expanded(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image
                  InkWell(
                    onTap: () {
                      _profilePicEdit();
                    },
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: dogSelected
                                  ? const AssetImage("assets/images/dog.jpeg")
                                  : const AssetImage("assets/images/cat.jpg"))),
                    ),
                  ),

                  // Name and Gender
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      // Name
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(color: AppColors.mainColor)),
                        child: TextField(
                          style: const TextStyle(fontSize: 18),
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: "Name *",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                backgroundColor: Colors.white,
                                fontSize: 14,
                              )),
                          onSubmitted: (value) {
                            // This callback is called when the user submits the text (e.g., presses enter).
                            print('Submitted text: $value');
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      // Gender
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () => _onGenderSelected('Male'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                side: const BorderSide(
                                    color: AppColors.mainColor, width: 1.0),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius15)),
                                backgroundColor: selectedGender == 'Male'
                                    ? AppColors.mainColor
                                    : Colors.transparent,
                                foregroundColor: selectedGender == 'Male'
                                    ? Colors.white
                                    : AppColors.mainColor,
                              ),
                              child: const Text(
                                'Male',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () => _onGenderSelected('Female'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                side: const BorderSide(
                                    color: AppColors.mainColor, width: 1.0),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius15)),
                                backgroundColor: selectedGender == 'Female'
                                    ? AppColors.mainColor
                                    : Colors.transparent,
                                foregroundColor: selectedGender == 'Female'
                                    ? Colors.white
                                    : AppColors.mainColor,
                              ),
                              child: const Text(
                                'Female',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),

                  // Line
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: AppColors.mainColor.withOpacity(0.4))),
                  ),

                  // Breed and pet type
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        // Pet Type
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Pet Type *',
                            labelStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.mainColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.mainColor, width: 1),
                            ),
                            filled: false,
                          ),
                          dropdownColor: Colors.white,
                          value: dropdownValue1,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue1 = newValue!;
                              if (dogSelected && newValue == "Dog") {
                              } else if (!dogSelected && newValue == "Dog") {
                                dogSelected = true;
                                dropdownValue2 = dogBreeds.first;
                              } else if (dogSelected && newValue == "Cat") {
                                dogSelected = false;
                                dropdownValue2 = catBreeds.first;
                              }
                            });
                          },
                          items: petTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Pet Breed
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Pet Breed *',
                            labelStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.mainColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: AppColors.mainColor, width: 1),
                            ),
                            filled: false,
                          ),
                          dropdownColor: Colors.white,
                          value: dogSelected ? dropdownValue2 : dropdownValue2,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue2 = newValue!;
                            });
                          },
                          items: dogSelected
                              ? dogBreeds.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                }).toList()
                              : catBreeds.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Line
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: AppColors.mainColor.withOpacity(0.4))),
                  ),

                  // Size
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Small
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  size1 = !size1;
                                  size2 = false;
                                  size3 = false;
                                  size4 = false;
                                });
                                _onSizeSelected();
                                print(selectedSize);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    bottom: 8, left: 3, right: 3),
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: size1
                                              ? AppColors.mainColor
                                              : AppColors.dogBasicPurple,
                                          spreadRadius: 2,
                                          blurRadius: 5),
                                    ]),
                                child: Text("Small",
                                    style: TextStyle(
                                        color: size1
                                            ? AppColors.mainColor
                                            : AppColors.dogBasicPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                            const Text(
                              "Below 30cm",
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),

                        // Medium
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  size1 = false;
                                  size2 = !size2;
                                  size3 = false;
                                  size4 = false;
                                });
                                _onSizeSelected();
                                print(selectedSize);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    bottom: 8, left: 3, right: 3),
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: size2
                                              ? AppColors.mainColor
                                              : AppColors.dogBasicPurple,
                                          spreadRadius: 2,
                                          blurRadius: 5),
                                    ]),
                                child: Text("Medium",
                                    style: TextStyle(
                                        color: size2
                                            ? AppColors.mainColor
                                            : AppColors.dogBasicPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                            const Text(
                              "30cm - 40cm",
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),

                        // Large
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  size1 = false;
                                  size2 = false;
                                  size3 = !size3;
                                  size4 = false;
                                });
                                _onSizeSelected();
                                print(selectedSize);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    bottom: 8, left: 3, right: 3),
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: size3
                                              ? AppColors.mainColor
                                              : AppColors.dogBasicPurple,
                                          spreadRadius: 2,
                                          blurRadius: 5),
                                    ]),
                                child: Text("Large",
                                    style: TextStyle(
                                        color: size3
                                            ? AppColors.mainColor
                                            : AppColors.dogBasicPurple,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                            const Text(
                              "40cm - 60cm",
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),

                        // Giant
                        dogSelected
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        size1 = false;
                                        size2 = false;
                                        size3 = false;
                                        size4 = !size4;
                                      });
                                      _onSizeSelected();
                                      print(selectedSize);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          bottom: 8, left: 3, right: 3),
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: size4
                                                    ? AppColors.mainColor
                                                    : AppColors.dogBasicPurple,
                                                spreadRadius: 2,
                                                blurRadius: 5),
                                          ]),
                                      child: Text("Giant",
                                          style: TextStyle(
                                              color: size4
                                                  ? AppColors.mainColor
                                                  : AppColors.dogBasicPurple,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  const Text(
                                    "Above 60cm",
                                    style: TextStyle(
                                        color: AppColors.mainColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),

                  // Line
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: AppColors.mainColor.withOpacity(0.4))),
                  ),

                  // Birthday
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          border: Border.all(
                              color: AppColors.mainColor, width: 1.0),
                        ),
                        child: TextField(
                          controller: dateInput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              iconColor: AppColors.mainColor,
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: "Birthday", //label text of field
                              labelStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              border: InputBorder.none),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(petBirthday),
                                firstDate: DateTime(1999),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Remove
                      InkWell(
                        onTap: () {
                          removeConfirmationDialog(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                            color: AppColors.catBasicRed,
                          ),
                          height: 45,
                          width: 120,
                          child: BigText(
                            text: "Remove Pet",
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Save
                      InkWell(
                        onTap: () {
                          bool isAllFilled = true;

                          // Perform text field validation
                          if (_nameController.text.isEmpty ||
                              selectedSize.isEmpty) {
                            isAllFilled = false;
                          }

                          if (isAllFilled) {
                            bool name = _nameController.text != petName;
                            bool gender = selectedGender != petGender;
                            bool type = dropdownValue1 != petType;
                            bool breed = dropdownValue2 != petBreed;
                            bool size = selectedSize != petSize;
                            bool birthday = dateInput.text != petBirthday;

                            Map<String, String> updatedData = {
                              if (name) 'name': _nameController.text,
                              if (gender) 'gender': selectedGender,
                              if (type) 'type': dropdownValue1,
                              if (breed) 'breed': dropdownValue2,
                              if (size) 'size': selectedSize,
                              if (birthday) 'birthday': dateInput.text,
                            };

                            updatePetByName(widget.petName, updatedData);
                            showLoadingDialog(context).then((value) =>
                                Navigator.popAndPushNamed(context, '/home'));
                            dispose();
                          } else {
                            showUnsuccessfulDialog(context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                            color: AppColors.mainColor,
                          ),
                          height: 45,
                          width: 120,
                          child: BigText(
                            text: "Save Changes",
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  removeSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50.0,
          ),
          content: Text(
            "Awww, you have successfully removed a pet from your account.. :(",
            style: TextStyle(
              color: Colors.green,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/home');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void removeConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Remove Confirmation'),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          content: SizedBox(
            height: 50,
            child: Text(
                'Are you sure you want to remove ${widget.petName.toUpperCase()} ?'),
          ),
          contentTextStyle: const TextStyle(
            color: AppColors.catBasicRed,
            fontSize: 17.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false); // Return false to indicate cancellation
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.paraColor, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Return true to indicate confirmation
              },
              child: const Text('Delete',
                  style: TextStyle(
                      color: AppColors.catBasicRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        removePet(widget.petName);
      } else {}
    });
  }

  showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50.0,
          ),
          content: Text(
            "You have successfully edited your pet information!",
            style: TextStyle(
              color: Colors.green,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/home');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  showUnsuccessfulDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: Icon(
            Icons.cancel,
            color: Colors.red,
            size: 50.0,
          ),
          content: Text(
            "Opps! Looks like you haven't fill up all the info yet! We will wait you 🐾",
            style: TextStyle(
              color: Colors.red,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
