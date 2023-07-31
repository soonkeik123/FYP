import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohmypet/pages/admin/loyalty_manage.dart';
import 'package:ohmypet/pages/admin/package_manage.dart';
import 'package:ohmypet/pages/admin/reservation_manage.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
import 'package:ohmypet/pages/home/main_home_page.dart';
import 'package:ohmypet/pages/pet/add_pet.dart';
import 'package:ohmypet/pages/profile/edit_profile_page.dart';
import 'package:ohmypet/pages/profile/loyalty_points.dart';
import 'package:ohmypet/pages/profile/main_profile_page.dart';
import 'package:ohmypet/pages/profile/signin_screen.dart';
import 'package:ohmypet/pages/profile/signup_screen.dart';
import 'package:ohmypet/pages/reservation/boarding_reservation.dart';
import 'package:ohmypet/pages/reservation/groom_reservation.dart';
import 'package:ohmypet/pages/reservation/main_reservation_page.dart';
import 'package:ohmypet/pages/reservation/vaccine_reservation.dart';
import 'package:ohmypet/pages/service/cat_boarding_info.dart';
import 'package:ohmypet/pages/service/cat_groom_info.dart';
import 'package:ohmypet/pages/service/dog_boarding_info.dart';
import 'package:ohmypet/pages/service/dog_groom_info.dart';
import 'package:ohmypet/pages/service/main_services_page.dart';
import 'package:ohmypet/pages/service/pet_vaccination.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oh My Pet',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignInScreen(),
      routes: {
        SignInScreen.routeName: (context) => const SignInScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        MainHomePage.routeName: (context) => const MainHomePage(),
        AddPetProfile.routeName: (context) => const AddPetProfile(),
        DogGroomInfo.dogBasicGroomInfo: (context) => DogGroomInfo(
              fullGrooming: false,
            ),
        DogGroomInfo.dogFullGroomInfo: (context) => DogGroomInfo(
              fullGrooming: true,
            ),
        DogBoardingInfo.routeName: (context) => const DogBoardingInfo(),
        CatGroomInfo.catBasicGroomInfo: (context) => CatGroomInfo(
              fullGrooming: false,
            ),
        CatGroomInfo.catFullGroomInfo: (context) => CatGroomInfo(
              fullGrooming: true,
            ),
        CatBoardingInfo.routeName: (context) => const CatBoardingInfo(),
        BoardingReservation.catBoardingReservation: (context) =>
            BoardingReservation(
              dogBoard: false,
            ),
        GroomReservationPage.catBasicGroomReservation: (context) =>
            GroomReservationPage(
              dogGroom: false,
              fullGroom: false,
            ),
        GroomReservationPage.catFullGroomReservation: (context) =>
            GroomReservationPage(
              dogGroom: false,
              fullGroom: true,
            ),
        GroomReservationPage.dogBasicGroomReservation: (context) =>
            GroomReservationPage(
              dogGroom: true,
              fullGroom: false,
            ),
        GroomReservationPage.dogFullGroomReservation: (context) =>
            GroomReservationPage(
              dogGroom: true,
              fullGroom: true,
            ),
        BoardingReservation.dogBoardingReservation: (context) =>
            BoardingReservation(
              dogBoard: true,
            ),
        PetVaccineInfo.routeName: (context) => const PetVaccineInfo(),
        VaccineReservationPage.routeName: (context) =>
            const VaccineReservationPage(),
        // TrackProgressPage.routeName: (context) => const TrackProgressPage(),
        MainServicePage.routeName: (context) => const MainServicePage(),
        MainReservationPage.routeName: (context) => const MainReservationPage(),
        MainProfilePage.routeName: (context) => const MainProfilePage(),
        EditProfilePage.routeName: (context) => const EditProfilePage(),
        LoyaltyPointPage.routeName: (context) => const LoyaltyPointPage(),
        ReservationManagement.staffRoute: (context) =>
            const ReservationManagement(
              role: "staff",
            ),
        ReservationManagement.adminRoute: (context) =>
            const ReservationManagement(
              role: "admin",
            ),
        LoyaltyManagement.routeName: (context) => const LoyaltyManagement(),
        PackageManagement.routeName: (context) => const PackageManagement(
              role: "admin",
            ),
        StaffManagement.routeName: (context) => const StaffManagement(
              role: "admin",
            ),
      },
    );
  }
}
