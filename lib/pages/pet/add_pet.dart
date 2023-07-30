import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/big_text.dart';
import '../../widgets/header.dart';

class AddPetProfile extends StatefulWidget {
  static const routeName = '/addPet';
  const AddPetProfile({super.key});

  @override
  State<AddPetProfile> createState() => _AddPetProfileState();
}

class _AddPetProfileState extends State<AddPetProfile> {
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petTypeController = TextEditingController();

  FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference dbRef;

  // Pet Type
  final List<String> petTypes = ['Dog', 'Cat'];
  bool dogSelected = true;
  bool size1 = false;
  bool size2 = false;
  bool size3 = false;
  bool size4 = false;

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

  // Date Picker
  TextEditingController dateInput = TextEditingController();

  String selectedGender = '';
  String selectedPetType = '';
  String selectedBreed = '';
  String selectedSize = '';

  @override
  void initState() {
    super.initState();
    dateInput.text = ""; //set the initial value of text field
    dbRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child('uid')
        .child('pets');
  }

  void saveData(Map pets) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(uid)
          .child('Pet');

      // Save the data under the user's UID
      String? newPetKey = userRef.push().key;
      userRef.child(newPetKey!).set({'data': pets}).then((_) {
        print('Data saved successfully!');
        Navigator.pop(context);
      }).catchError((error) {
        print('Error saving data: $error');
      });
    } else {
      print('User is not authenticated.');
    }
  }

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _onTypeSelected(String petType) {
    setState(() {
      selectedPetType = petType;
    });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Dog';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        const CustomHeader(
          pageTitle: "Add Pet Profile",
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
                  // Name
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      TitleText(
                        text: "How do we call your Pet?",
                        size: 19,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: petNameController,
                        decoration: InputDecoration(
                          labelText: 'Pet name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: AppColors.mainColor, width: 2.0),
                          ),
                        ),
                        onSubmitted: (value) {
                          // This callback is called when the user submits the text (e.g., presses enter).
                          print('Submitted text: $value');
                        },
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      // Button
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
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        TitleText(
                          text: "What breed is your Pet?",
                          size: 19,
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Pet Type
                        DropdownButtonFormField(
                          decoration: InputDecoration(
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
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              if (newValue == "Dog" && !dogSelected) {
                                selectedBreed = dogBreeds.first;
                              } else if (newValue == "Cat" && dogSelected) {
                                selectedBreed = catBreeds.first;
                              }

                              dogSelected = (newValue == "Dog") ? true : false;

                              _onTypeSelected(dropdownValue);
                            });
                          },
                          items: petTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 20),
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
                          value:
                              dogSelected ? dogBreeds.first : catBreeds.first,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBreed = newValue!;
                            });
                          },
                          items: dogSelected
                              ? dogBreeds.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList()
                              : catBreeds.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 20),
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
                                  setState(() {
                                    size1 = !size1;
                                    size2 = false;
                                    size3 = false;
                                    size4 = false;
                                  });
                                });
                                _onSizeSelected();
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
                            Text(
                              dogSelected ? "Below 30cm" : "Below 20cm",
                              style: const TextStyle(
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
                                  setState(() {
                                    size1 = false;
                                    size2 = !size2;
                                    size3 = false;
                                    size4 = false;
                                  });
                                });
                                _onSizeSelected();
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
                            Text(
                              dogSelected ? "30cm - 40cm" : "20cm - 35cm",
                              style: const TextStyle(
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
                                  setState(() {
                                    size1 = false;
                                    size2 = false;
                                    size3 = !size3;
                                    size4 = false;
                                  });
                                });
                                _onSizeSelected();
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
                            Text(
                              dogSelected ? "40cm - 60cm" : "Above 35cm",
                              style: const TextStyle(
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
                      TitleText(
                        text: "When is the birthday",
                        size: 19,
                      ),
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
                              border: InputBorder.none),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
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

                  // Next Button
                  InkWell(
                    onTap: () {
                      Map<String, String> pets = {
                        'name': petNameController.text,
                        'gender': selectedGender,
                        'type': selectedPetType,
                        'breed': selectedBreed,
                        'size': selectedSize,
                        'birthday': dateInput.text
                      };
                      saveData(pets);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      height: 40,
                      child: BigText(
                        text: "Save",
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}