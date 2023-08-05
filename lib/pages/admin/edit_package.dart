import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

class EditPackagePage extends StatefulWidget {
  final String packageID;
  const EditPackagePage({super.key, required this.packageID});

  @override
  State<EditPackagePage> createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  // Create a reference to Firebase database
  late DatabaseReference packageRef;

  File? _chosenImage;
  final ImagePicker _picker = ImagePicker();
  String storeImagePath = '';

  @override
  void initState() {
    super.initState();

    getSelectedPackageData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // header
          const AdminHeader(pageTitle: "Add Package"),

          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _showBottomSheet(context),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _chosenImage != null
                              ? Image.file(_chosenImage!, fit: BoxFit.cover)
                              : const Icon(Icons.add_photo_alternate,
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
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Textfield for package title
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.mainColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.mainColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Enter package name',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Textfield for user description
                      TextField(
                        controller: _descriptionController,
                        keyboardType: TextInputType
                            .multiline, // Use multiline keyboard type
                        maxLines:
                            null, // Remove the limit on the number of lines
                        textInputAction: TextInputAction
                            .newline, // Set the action to newline
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.mainColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.mainColor, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Enter package description',
                          labelText: 'Package description',
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Textfield for package title
                          TextField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: 'Enter package price',
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Save
                          Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () async {
                                if (_chosenImage != null) {
                                  bool isAllField = true;
                                  if (_titleController.text.isEmpty ||
                                      _descriptionController.text.isEmpty ||
                                      _priceController.text.isEmpty) {
                                    isAllField = false;
                                    showMessageDialog(context, "Failed to Save",
                                        "Package info is required. Please make sure you have filled in the information.");
                                  }
                                  if (isAllField) {
                                    await saveImageLocally(_chosenImage!);

                                    DatabaseReference packageRef =
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child('packages')
                                            .child(widget.packageID);

                                    Map<String, dynamic> packageData = {
                                      'title': _titleController.text,
                                      'description':
                                          _descriptionController.text,
                                      'price': _priceController.text,
                                      'imageUrl': storeImagePath,
                                    };

                                    packageRef.set(packageData).then((_) {
                                      // Clear data
                                      Clear();
                                      print('Package edited successfully!');
                                      showSuccessDialog(
                                          context,
                                          "EDIT SUCCESSFUL",
                                          "You have edited an existing package successfully! Let's check it out!");
                                    }).catchError((error) {
                                      print('Error saving data: $error');
                                    });
                                  }
                                } else {
                                  showMessageDialog(context, "Failed to Save",
                                      "Package image is required. Please make sure you have uploaded an image.");
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
                                  color: AppColors.mainColor,
                                ),
                                height: 45,
                                width: 160,
                                child: BigText(
                                  text: "Save Changes",
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop the dialog
                Navigator.pop(context); // Pop the current page
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMessageDialog(
      BuildContext context, String titleText, String contentText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
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

  Clear() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
  }

  Future<void> getSelectedPackageData() async {
    final pid = widget.packageID;

    final DatabaseReference packageRef = FirebaseDatabase.instance.ref();
    final snapshot = await packageRef.child('packages/$pid').get();

    if (snapshot.exists) {
      Clear();
      final Map existPackage = snapshot.value as Map;
      setState(() {
        _titleController.text = existPackage['title'];
        // _imageUController = existPackage['imageUrl'];
        _descriptionController.text = existPackage['description'];
        _priceController.text = existPackage['price'];
        _chosenImage = File(existPackage['imageUrl']);
      });
    } else {
      print('No data available');
    }
  }
}
