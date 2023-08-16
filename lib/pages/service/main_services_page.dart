import 'package:flutter/material.dart';
import 'package:ohmypet/pages/service/pet_vaccination.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/header.dart';

import '../../widgets/bottom_navigation_bar.dart';

class MainServicePage extends StatefulWidget {
  static const routeName = '/service';
  const MainServicePage({super.key});

  @override
  State<MainServicePage> createState() => _MainServicePageState();
}

class _MainServicePageState extends State<MainServicePage> {
  final List<Map<String, dynamic>> servicesItem = [
    {"imagePath": "assets/images/dog-basic-grooming.png"},
    {"imagePath": "assets/images/dog-full-grooming.png"},
    {"imagePath": "assets/images/cat-basic-grooming.png"},
    {"imagePath": "assets/images/cat-full-grooming.png"},
    {"imagePath": "assets/images/petBoarding.png"},
    {"imagePath": "assets/images/petBoarding.png"},
    {"imagePath": "assets/images/petVaccine.png"},
  ];

  final List<Map<String, dynamic>> gridData = [
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
      'title': 'Pet Vaccine\n(Inquiry)',
      'color': '0xFFE65100',
      'imageURL': 'assets/images/petVaccine.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: "SERVICES"),

          // showing the body
          // List View of Variety Services
          Expanded(
            child: Container(
              height: double.maxFinite,
              padding: EdgeInsets.only(bottom: Dimensions.height20),
              margin: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 8.5,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.transparent,
                          border: Border.all(
                              color: Color(int.parse(gridData[index]['color'])),
                              width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              (gridData[index]['imageURL']),
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              gridData[index]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                color:
                                    Color(int.parse(gridData[index]['color'])),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (index == 0) {
                          Navigator.pushNamed(
                            context,
                            '/catBasicGroomInfo',
                          );
                        } else if (index == 1) {
                          Navigator.pushNamed(
                            context,
                            '/dogBasicGroomInfo',
                          );
                        } else if (index == 2) {
                          Navigator.pushNamed(
                            context,
                            '/catFullGroomInfo',
                          );
                        } else if (index == 3) {
                          Navigator.pushNamed(
                            context,
                            '/dogFullGroomInfo',
                          );
                        } else if (index == 4) {
                          Navigator.pushNamed(
                            context,
                            '/catBoardingInfo',
                          );
                        } else if (index == 5) {
                          Navigator.pushNamed(
                            context,
                            '/dogBoardingInfo', // Replace NewPage with the name of your new page class
                          );
                        } else if (index == 6) {
                          Navigator.pushNamed(
                            context,
                            PetVaccineInfo.routeName,
                          ); // Replace NewPage with the name of your new page class
                        }
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        activePage: 1,
      ),
    );
  }
}
