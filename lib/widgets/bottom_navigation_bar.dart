import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  // The "activePage" should be passed when you create the Widget
  final int activePage;

  const BottomNavBar({Key? key, required this.activePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

        // Set the currentIndex to a desired value
        currentIndex: activePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppColors.petBoarding,
        unselectedLabelStyle: const TextStyle(
          color: AppColors.dogBasicPurple,
        ),
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.dogBasicPurple,
        backgroundColor: AppColors.themeColor,
        onTap: (int idx) {
          if (idx == 0 && activePage != idx) {
            Navigator.popAndPushNamed(
              context,
              '/home',
            );
          } else if (idx == 1 && activePage != idx) {
            Navigator.popAndPushNamed(
              context,
              '/service',
            );
          } else if (idx == 2 && activePage != idx) {
            Navigator.popAndPushNamed(
              context,
              '/reservation',
            );
          } else if (idx == 3 && activePage != idx) {
            Navigator.popAndPushNamed(
              context,
              '/profile',
            );
          }
        });
  }
}
