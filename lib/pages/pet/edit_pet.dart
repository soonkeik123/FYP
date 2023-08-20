import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/big_text.dart';
import '../../widgets/header.dart';

class EditPetProfile extends StatefulWidget {
  static const routeName = '/editPet';
  final String petId;
  const EditPetProfile({super.key, required this.petId});

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
  // Pet Type
  final TextEditingController petTypeController = TextEditingController();
  // Pet Breed
  final TextEditingController petBreedController = TextEditingController();
  // Gender
  String selectedGender = '';
  // Pet type
  String dropdownValue = '';

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
  String imageUrl = '';

  String selectedSize = '';

  // Dog Breed
  final List<String> dogBreeds = [
    'Affenpinscher',
    'Afghan Hound',
    'Airedale Terrier',
    'Akita',
    'Alaskan Klee Kai',
    'Alaskan Malamute',
    'American Bulldog',
    'American Cocker Spaniel',
    'American Eskimo Dog',
    'American Foxhound',
    'American Pit Bull Terrier',
    'American Staffordshire Terrier',
    'Anatolian Shepherd Dog',
    'Australian Cattle Dog',
    'Australian Shepherd',
    'Australian Terrier',
    'Basenji',
    'Basset Hound',
    'Beagle',
    'Bearded Collie',
    'Beauceron',
    'Bedlington Terrier',
    'Belgian Malinois',
    'Belgian Sheepdog',
    'Belgian Tervuren',
    'Bernese Mountain Dog',
    'Bichon Frise',
    'Black and Tan Coonhound',
    'Bloodhound',
    'Border Collie',
    'Border Terrier',
    'Borzoi',
    'Boston Terrier',
    'Bouvier des Flandres',
    'Boxer',
    'Briard',
    'Brittany',
    'Brussels Griffon',
    'Bull Terrier',
    'Bulldog (English)',
    'Bulldog (French)',
    'Bullmastiff',
    'Cairn Terrier',
    'Canaan Dog',
    'Chesapeake Bay Retriever',
    'Chihuahua',
    'Chinese Crested',
    'Chinese Shar-Pei',
    'Chow Chow',
    'Clumber Spaniel',
    'Cockapoo',
    'Cocker Spaniel',
    'Collie',
    'Coonhound',
    'Corgi',
    'Coton de Tulear',
    'Curly-Coated Retriever',
    'Dachshund',
    'Dalmatian',
    'Dandie Dinmont Terrier',
    'Doberman Pinscher',
    'Dogue de Bordeaux',
    'Dutch Shepherd',
    'English Bulldog',
    'English Cocker Spaniel',
    'English Foxhound',
    'English Setter',
    'English Springer Spaniel',
    'English Toy Spaniel',
    'Entlebucher Mountain Dog',
    'Eskimo Dog',
    'Field Spaniel',
    'Finnish Lapphund',
    'Finnish Spitz',
    'Flat-Coated Retriever',
    'French Bulldog',
    'German Pinscher',
    'German Shepherd Dog',
    'German Shorthaired Pointer',
    'German Wirehaired Pointer',
    'Giant Schnauzer',
    'Glen of Imaal Terrier',
    'Goldador',
    'Golden Retriever',
    'Goldendoodle',
    'Gordon Setter',
    'Great Dane',
    'Great Pyrenees',
    'Greater Swiss Mountain Dog',
    'Greyhound',
    'Harrier',
    'Havanese',
    'Irish Setter',
    'Irish Terrier',
    'Irish Water Spaniel',
    'Irish Wolfhound',
    'Italian Greyhound',
    'Jack Russell Terrier',
    'Japanese Chin',
    'Japanese Spitz',
    'Keeshond',
    'Kerry Blue Terrier',
    'King Charles Spaniel',
    'Klee Kai',
    'Komondor',
    'Kuvasz',
    'Labradoodle',
    'Labrador',
    'Lakeland Terrier',
    'Lhasa Apso',
    'Lowchen',
    'Maltese',
    'Manchester Terrier',
    'Mastiff',
    'Miniature Bull Terrier',
    'Miniature Pinscher',
    'Miniature Schnauzer',
    'Neapolitan Mastiff',
    'Newfoundland',
    'Norfolk Terrier',
    'Norwegian Elkhound',
    'Norwich Terrier',
    'Old English Sheepdog',
    'Otterhound',
    'Papillon',
    'Pekingese',
    'Pembroke Welsh Corgi',
    'Petit Basset Griffon Vendeen',
    'Pharaoh Hound',
    'Plott',
    'Pocket Beagle',
    'Pointer',
    'Pomeranian',
    'Poodle',
    'Portuguese Water Dog',
    'Pug',
    'Puli',
    'Pumi',
    'Rat Terrier',
    'Redbone Coonhound',
    'Rhodesian Ridgeback',
    'Rottweiler',
    'Saint Bernard',
    'Saluki',
    'Samoyed',
    'Schipperke',
    'Scottish Deerhound',
    'Scottish Terrier',
    'Sealyham Terrier',
    'Shetland Sheepdog',
    'Shiba Inu',
    'Shih Tzu',
    'Siberian Husky',
    'Silky Terrier',
    'Skye Terrier',
    'Sloughi',
    'Small Munsterlander Pointer',
    'Soft-Coated Wheaten Terrier',
    'Spanish Water Dog',
    'Spinone Italiano',
    'Staffordshire Bull Terrier',
    'Standard Schnauzer',
    'Sussex Spaniel',
    'Swedish Vallhund',
    'Tibetan Mastiff',
    'Tibetan Spaniel',
    'Tibetan Terrier',
    'Toy Fox Terrier',
    'Vizsla',
    'Weimaraner',
  ];

  final List<String> catBreeds = [
    'Abyssinian',
    'American Bobtail',
    'American Curl',
    'American Shorthair',
    'Arabian Mau',
    'Asian',
    'Asian Semi-longhair',
    'Australian Mist',
    'Balinese',
    'Bengal',
    'Birman',
    'Brazilian Shorthair',
    'British Shorthair',
    'Burmese',
    'Burmilla',
    'California Spangled',
    'Chantilly-Tiffany',
    'Chartreux',
    'Chausie',
    'Cheetoh',
    'Colorpoint Shorthair',
    'Cornish Rex',
    'Cymric',
    'Devon Rex',
    'Dragon Li',
    'Egyptian Mau',
    'European Burmese',
    'European Shorthair',
    'Exotic Shorthair',
    'Havana Brown',
    'Highlander',
    'Himalayan',
    'Japanese Bobtail',
    'Khaomanee',
    'Kinkalow',
    'Korat',
    'Kurilian Bobtail',
    'Kuril Islands Bobtail',
    'LaPerm',
    'Lykoi',
    'Maine Coon',
    'Manx',
    'Minskin',
    'Munchkin',
    'Nebelung',
    'Norwegian Forest',
    'Ocicat',
    'Ojos Azules',
    'Oriental Shorthair',
    'Oregon Rex',
    'Peterbald',
    'Pixie-bob',
    'Pixiebob',
    'Persian',
    'Ragdoll',
    'Russian Angora',
    'Russian Black White',
    'Russian Blue',
    'Russian White',
    'Savannah',
    'Scottish Fold',
    'Scottish Fold Longhair',
    'Scottish Shorthair',
    'Selkirk Rex',
    'Serengeti',
    'Siamese',
    'Siberian',
    'Siberian Forest Cat',
    'Singapura',
    'Snowshoe',
    'Sphynx',
    'Suphalak',
    'Thai',
    'Thailand Cat',
    'Tiffany',
    'Tonkinese',
    'Tonkinese Solid',
    'Traditional Siamese',
    'Turkish Angora',
    'Turkish Van',
    'Ukrainian Levkoy',
    'Ural Rex',
    'Wila Krungthep',
    'York Chocolate Cat',
  ];

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  File? _chosenImage;
  final ImagePicker _picker = ImagePicker();
  String storeImagePath = '';

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
    setPetProfile();
  }

  @override
  void dispose() {
    super.dispose();
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
          if (imageUrl.isNotEmpty) _chosenImage = File(imageUrl);
        });
        setPetProfile();
      } else {
        print("Loading error, unnecessary if else.");
      }
    } else {
      print("Pet not found.");
    }
  }

  // Shows option when user clicked on profile image
  void _profilePicEdit() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                // Call the image picker function here
                openImagePicker();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Implementing image picker
  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _chosenImage = File(pickedImage.path);
      });
    }
  }

  Future<void> saveImageLocally(File imageFile) async {
    // Get the path to the application's documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    // Get the original filename of the image
    String originalFilename = imageFile.path.split('/').last;

    // Define a new file in the documents directory with the original filename
    final savedImage = File('${appDocDir.path}/$originalFilename');

    // Copy the chosen image to the new file
    await imageFile.copy(savedImage.path);

    storeImagePath = savedImage.path;

    print('Image saved locally: ${savedImage.path}');
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
    } else {
      setState(() {
        selectedSize = ''; // No size is selected
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
      // Pet Typev
      if (petType == 'Dog') {
        dogSelected = true;
      } else {
        dogSelected = false;
      }
      // Pet Type
      petTypeController.text = petType;
      // Pet Breed
      petBreedController.text = petBreed;
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
      _onSizeSelected();
      // Birthday
      dateInput.text = petBirthday;
    });
  }

  void removePet(String name) {
    // Construct the reference to the specific pet's data using the petKey directly
    DatabaseReference petRef = dbPetRef.child(widget.petId);

    // Call the remove() method on the reference to delete the pet
    petRef.remove().then((_) {
      print(
          "Pet with name ${widget.petId} and key ${widget.petId} removed successfully.");
      removeSuccessDialog(context);
    }).catchError((error) {
      print(
          "Error removing pet with name ${widget.petId} and key ${widget.petId}: $error");
    });
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent the dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
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
    await Future.delayed(const Duration(seconds: 2));

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
                    onTap: () => _profilePicEdit(),
                    child: Column(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(
                                75), // Half of the width or height to make it circular
                          ),
                          child: _chosenImage != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        75), // To make the image inside circular
                                    image: DecorationImage(
                                      image: FileImage(_chosenImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Icon(Icons.add_photo_alternate,
                                  size: 40, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Upload Image",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
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
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color: AppColors.mainColor)),
                          child: TextField(
                            style: const TextStyle(fontSize: 18),
                            controller: petTypeController,
                            decoration: InputDecoration(
                                enabled: false,
                                labelText: "Pet Type *",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.black54,
                                  backgroundColor: Colors.white,
                                  fontSize: 14,
                                )),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Pet Breed
                        TypeAheadFormField<String?>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: petBreedController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: AppColors.mainColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: AppColors.mainColor,
                                  width: 1,
                                ),
                              ),
                              filled: false,
                              labelText: 'Pet Breed *',
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return dogSelected
                                ? dogBreeds
                                    .where((breed) => breed
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                    .toList()
                                : catBreeds
                                    .where((breed) => breed
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                    .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(title: Text(suggestion!));
                          },
                          onSuggestionSelected: (suggestion) {
                            petBreedController.text = suggestion!;
                          },
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
                        onTap: () async {
                          print(selectedSize);
                          print(petBreedController.text);
                          print(_nameController.text);
                          bool isAllFilled = true;

                          // Perform text field validation
                          if (_nameController.text.isEmpty ||
                              selectedSize.isEmpty ||
                              petBreedController.text.isEmpty) {
                            isAllFilled = false;
                          }

                          if (isAllFilled) {
                            if (_chosenImage != null) {
                              await saveImageLocally(_chosenImage!);
                            }

                            bool name = _nameController.text != petName;
                            bool gender = selectedGender != petGender;
                            bool type = dropdownValue != petType;
                            bool breed = petBreedController.text != petBreed;
                            bool size = selectedSize != petSize;
                            bool birthday = dateInput.text != petBirthday;
                            bool image = imageUrl != storeImagePath;

                            Map<String, String> updatedData = {
                              if (name) 'name': _nameController.text,
                              if (gender) 'gender': selectedGender,
                              if (type) 'type': dropdownValue,
                              if (breed) 'breed': petBreedController.text,
                              if (size) 'size': selectedSize,
                              if (birthday) 'birthday': dateInput.text,
                              if (image) 'imageUrl': storeImagePath,
                            };

                            final petRef = dbPetRef.child(widget.petId);
                            petRef
                                .update(updatedData)
                                .then((value) => showSuccessDialog(context));
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
          title: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50.0,
          ),
          content: const Text(
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
              child: const Text('OK'),
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
            child: Text('Are you sure you want to remove your pet ?'),
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
        removePet(widget.petId);
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
          title: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50.0,
          ),
          content: const Text(
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
              child: const Text('OK'),
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
          title: const Icon(
            Icons.cancel,
            color: Colors.red,
            size: 50.0,
          ),
          content: const Text(
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
