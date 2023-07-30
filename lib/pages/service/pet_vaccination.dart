import 'package:flutter/material.dart';
import 'package:ohmypet/pages/reservation/vaccine_reservation.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/expandable_text.dart';
import 'package:ohmypet/widgets/header.dart';

class PetVaccineInfo extends StatelessWidget {
  static const routeName = '/petVaccineInfo';
  const PetVaccineInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const CustomHeader(
              pageTitle: "Pet Vaccination",
            ),

            Stack(
              children: [
                Container(
                  color: AppColors.themeColor,
                  height: 120,
                ),
                Container(
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height30),
                        height: 150,
                        child: Image.asset("assets/images/petVaccine.png"),
                      ),
                      // DOG Title
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: const Color(0xFFFF8F00),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width30,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width30),
                        child: Text(
                          "DOG",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font20,
                            decorationThickness: 2.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Dog Vaccine Introduction
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 5),
                        child: const Column(
                          children: [
                            ExpandableText(
                                vaccineName: "Rabies Vaccine",
                                description:
                                    "Rabies is a fatal viral disease that attacks the nervous system and that is transmissible to humans."),
                            ExpandableText(
                                vaccineName: "Distemper Vaccine",
                                description:
                                    "Distemper is a viral disease that is often fatal, affecting the respiratory and gastrointestinal tracts and often the nervous system."),
                            ExpandableText(
                                vaccineName: "Parvovirus Vaccine",
                                description:
                                    "Canine parvovirus is a viral disease that causes severe vomiting and diarrhea and can be fatal"),
                            ExpandableText(
                                vaccineName: "Parainfluenza Vaccine",
                                description:
                                    "Parainfluenza is a viral disease affecting the respiratory system; may be involved in the development of kennel cough."),
                          ],
                        ),
                      ),

                      // CAT Title
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: const Color(0xFF18FFFF),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width30,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.width30),
                        child: Text(
                          "CAT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font20,
                            decorationThickness: 2.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // CAT Vaccine Introduction
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 5),
                        child: const Column(
                          children: [
                            ExpandableText(
                                vaccineName: "Feline Panleukopenia Vaccine",
                                description:
                                    "feline panleukopenia virus is a highly contagious, severe infection that affects a kitten's or cat's nervous and immune system and the gastrointestinal system. Feline distemper has a more severe effect on kittens than cats."),
                            ExpandableText(
                                vaccineName: "Rabies Vaccine",
                                description:
                                    "Rabies is a virus that causes the brain to become inflamed. This disease affects humans and other mammals. Rabies spreads through a bite from an infected animal and can be spread to humans."),
                            ExpandableText(
                                vaccineName: "Feline Rhinotracheitis Vaccine",
                                description:
                                    "Feline Rhinotracheitis virus affects kittens and cats of all ages. FVR is spread by direct contact with the virus' particles in the saliva and discharge from the nose and eyes of an infected kitten or cat."),
                            ExpandableText(
                                vaccineName: "Feline Calicivirus Vaccine",
                                description:
                                    "Feline calicivirus causes oral disease and different upper respiratory infections in cats. Calicivirus is a highly contagious disease that is spread from one cat to another through the saliva of an infected cat and discharge from the nose and eyes. An infected cat can sneeze and spread these viral particles throughout the air."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        // margin: EdgeInsets.only(bottom: 15, left: 35, right: 35),
        width: 250,
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(Dimensions.radius30),
          color: AppColors.mainColor,
        ),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VaccineReservationPage()));
            },
            child: Text(
              "Make Reservation",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.font20,
              ),
            )),
      ),
    );
  }
}
