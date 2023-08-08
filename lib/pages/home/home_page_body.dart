import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/pet/view_pet.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/small_text.dart';

import '../admin/package_manage.dart';
import '../pet/edit_pet.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final List<Map> petDataList = [];
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  void refreshItems(Map pet) {
    setState(() {
      // Simulate a data refresh by adding a new item to the list
      petDataList.add(pet);
    });
  }

  PageController pageController = PageController(
      viewportFraction: 0.85); // Decide the space between each slide
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = 220;

  late List<Map> packages = [];
  late List<String> packageID = [];

  final List<Map<String, dynamic>> serviceData = [
    {
      'title': 'Cat Basic Grooming',
      'color': '0xFFC62828',
      'imageURL': 'assets/images/cat-basic-grooming.png',
    },
    {
      'title': 'Dog Basic Grooming',
      'color': '0xFF7986CB',
      'imageURL': 'assets/images/dog-basic-grooming.png',
    },
    {
      'title': 'Cat Full Grooming',
      'color': '0xFF8D6E63',
      'imageURL': 'assets/images/cat-full-grooming.png',
    },
    {
      'title': 'Dog Full Grooming',
      'color': '0xFFFF9E80',
      'imageURL': 'assets/images/dog-full-grooming.png',
    },
    {
      'title': 'Cat Boarding',
      'color': '0xFF0D47B7',
      'imageURL': 'assets/images/petBoarding.png',
    },
    {
      'title': 'Dog Boarding',
      'color': '0xFF388E3C',
      'imageURL': 'assets/images/petBoarding.png',
    },
    {
      'title': 'Pet Vaccine',
      'color': '0xFFE65100',
      'imageURL': 'assets/images/petVaccine.png',
    },
  ];

  bool isDog = true;
  List<GlobalKey> itemKeys = [];

  @override
  void initState() {
    // print("actual size = ${Dimensions.screenHeight}");

    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      dbPetRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(uid)
          .child('Pet');
    }

    getAllPackage();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
    // dispose the unnecessary data from initState() to keep memory used small
  }

  @override
  Widget build(BuildContext context) {
    dbPetRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        petDataList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<dynamic, dynamic> petData =
              Map.from(value); // Access the inner map
          petData['key'] = key;
          refreshItems(petData);
        });
      }
    });

    return Stack(
      children: [
        Container(
          color: AppColors.themeColor,
          height: 120,
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              // slider section
              petDataList.isNotEmpty
                  ? SizedBox(
                      height: Dimensions.pageView + 15,
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: petDataList.length,
                          itemBuilder: (context, position) {
                            return _buildPageItem(position,
                                pet: petDataList[position]);
                          }),
                    )
                  : SizedBox(
                      height: Dimensions.pageView + 15,
                      child: Stack(
                        children: [
                          Container(
                            height: Dimensions.pageViewTextContainer,
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(15),
                            margin: EdgeInsets.only(
                                left: Dimensions.width30,
                                right: Dimensions.width30,
                                bottom: Dimensions.height30),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                color: AppColors.mainColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFe8e8e8),
                                    blurRadius: 5.0,
                                    offset: Offset(0, 5),
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Text(
                                  "Add Your Pets Here",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimensions.font20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/addPet');
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Add Pet",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    )),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 140,
                              child: InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/addPet'),
                                child: Container(
                                  child: Image.asset(
                                    "assets/images/cute-image-2.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              // dots
              DotsIndicator(
                // Dots Indicator
                dotsCount: petDataList.isNotEmpty ? petDataList.length : 1,
                position: _currPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.mainColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),

              SizedBox(
                height: Dimensions.height30,
              ),

              // Services Text
              Container(
                margin: EdgeInsets.only(left: Dimensions.width30),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  BigText(text: "Services"),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: BigText(
                      text: ".",
                      color: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SmallText(text: "Comprehensive Care"),
                  ),
                ]),
              ),

              SizedBox(
                height: Dimensions.height20,
              ),

              // List View of Variety Services
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        // Item generated
                        child: Container(
                          height: 140,
                          width: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            border: Border.all(
                                color: Color(
                                    int.parse(serviceData[index]['color'])),
                                width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          serviceData[index]['imageURL']),
                                    )),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 130,
                                // margin: EdgeInsets.symmetric(horizontal: 25),
                                alignment: Alignment.center,
                                child: Text(
                                  serviceData[index]['title'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(int.parse(
                                          serviceData[index]['color']))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (index == 0) {
                            Navigator.pushNamed(context, '/catBasicGroomInfo');
                          } else if (index == 1) {
                            Navigator.pushNamed(context, '/dogBasicGroomInfo');
                          } else if (index == 2) {
                            Navigator.pushNamed(context, '/catFullGroomInfo');
                          } else if (index == 3) {
                            Navigator.pushNamed(context, '/dogFullGroomInfo');
                          } else if (index == 4) {
                            Navigator.pushNamed(context, '/catBoardingInfo');
                          } else if (index == 5) {
                            Navigator.pushNamed(context, '/dogBoardingInfo');
                          } else if (index == 6) {
                            Navigator.pushNamed(context, '/petVaccineInfo');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: Dimensions.height30,
              ),

              // Package text
              Container(
                margin: EdgeInsets.only(left: Dimensions.width30),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  BigText(text: "Package"),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: BigText(
                      text: ".",
                      color: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SmallText(text: "Service Combination"),
                  ),
                ]),
              ),

              // List of service and images
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 430,
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: packages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (130 / 160),
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 14.0,
                  ),
                  itemBuilder: (context, index) {
                    final GlobalKey itemKey = GlobalKey();
                    itemKeys.add(itemKey);

                    return GestureDetector(
                      onTap: () => _showPackageDetail(context, index, itemKey),
                      child: PackageItem(
                        key: itemKey,
                        title: packages[index]['title'],
                        imageUrl: packages[index]['imageUrl'],
                        description: packages[index]['description'],
                        price: double.parse(packages[index]['price']),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // View Package item detail
  void _showPackageDetail(BuildContext context, int index, GlobalKey itemKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(packages[index]['imageUrl']),
                  height: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  packages[index]['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  packages[index]['description'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: RM ${packages[index]['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle the button action here (if needed)
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageItem(int index, {required Map pet}) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewTextContainer,
            width: double.maxFinite,
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.only(
                left: Dimensions.width15,
                right: Dimensions.width15,
                bottom: Dimensions.height30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: AppColors.mainColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  ),
                ]),
            child: Column(children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPetPage(
                                petId: pet['key'],
                              )));
                },
                child: Text(
                  pet['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font20,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPetProfile(
                                    petId: pet['key'],
                                  )));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    child: const Text(
                      "Edit Pet",
                      style: TextStyle(color: AppColors.mainColor),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addPet');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ),
                      child: const Text(
                        "Add Pet",
                        style: TextStyle(color: AppColors.mainColor),
                      )),
                ],
              )
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 160,
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPetPage(
                              petId: pet['key'],
                            ))),
                child: Container(
                  child: Image.asset(
                    pet['type'] == "Dog"
                        ? "assets/images/Dog Icon.png"
                        : "assets/images/Cat Icon.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAllPackage() async {
    final ref = FirebaseDatabase.instance.ref();
    final event = await ref.child('packages').once(DatabaseEventType.value);

    final packageSnapshot = event.snapshot;
    packages.clear();
    packageID.clear();
    Map packagesItem = packageSnapshot.value as Map;
    packagesItem.forEach((key, value) {
      packages.add(value);
      packageID.add(key);
    });
  }
}
