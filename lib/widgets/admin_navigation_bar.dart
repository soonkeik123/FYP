import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';

class AdminBottomNavBar extends StatelessWidget {
  // The "activePage" should be passed when create the Widget
  final int activePage;
  final String role;

  const AdminBottomNavBar(
      {Key? key, required this.activePage, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (role == 'staff') {
      return BottomNavigationBar(

          // Set the currentIndex to a desired value
          currentIndex: activePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars_rounded),
              label: 'Loyalty',
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
                '/staffManageReservation',
              );
            } else if (idx == 1 && activePage != idx) {
              Navigator.popAndPushNamed(
                context,
                '/loyaltyManagement',
              );
            }
          });
    } else {
      return BottomNavigationBar(

          // Set the currentIndex to a desired value
          currentIndex: activePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars_rounded),
              label: 'Loyalty',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_rounded),
              label: 'Package',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Staff',
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
                '/adminManageReservation',
              );
            } else if (idx == 1 && activePage != idx) {
              Navigator.popAndPushNamed(
                context,
                '/loyaltyManagement',
              );
            } else if (idx == 2 && activePage != idx) {
              Navigator.popAndPushNamed(
                context,
                '/packageManagement',
              );
            } else if (idx == 3 && activePage != idx) {
              Navigator.popAndPushNamed(
                context,
                '/staffManagement',
              );
            }
          });
    }
  }
}
