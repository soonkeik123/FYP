import 'package:flutter/material.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/admin_navigation_bar.dart';

class PackageManagement extends StatefulWidget {
  static const routeName = '/packageManagement';
  final String role;
  const PackageManagement({super.key, required this.role});

  @override
  State<PackageManagement> createState() => _PackageManagementState();
}

class _PackageManagementState extends State<PackageManagement> {
  late String role;

  @override
  void initState() {
    super.initState();

    role = widget.role;
  }

  final List<Map<String, dynamic>> gridData = [
    {
      'title': 'August Super Saver',
      'imageUrl': 'assets/images/p4.png',
      'description':
          'Enjoy our August saver by booking any kind of services, with FREE pet taxi fee!',
      'price': 90,
    },
    {
      'title': 'Pampered Pooch Package',
      'imageUrl': 'assets/images/p1.png',
      'description':
          'Treat your furry friend with our Pampered Pooch Package, including a luxurious bath, grooming, and massage!',
      'price': 120,
    },
    {
      'title': 'Kitty Cuddle Time',
      'imageUrl': 'assets/images/p2.png',
      'description':
          'Give your kitty some extra love and cuddle time with our Kitty Cuddle Time service!',
      'price': 60,
    },
    {
      'title': 'Puppy Playdate',
      'imageUrl': 'assets/images/p3.png',
      'description':
          'Let your puppy socialize and have fun with other adorable pups in our Puppy Playdate!',
      'price': 50,
    },
    {
      'title': 'Boarding Saver',
      'imageUrl': 'assets/images/p2.png',
      'description':
          'Enjoy a super deal of 50% discount on a pet boarding service!!',
      'price': 30,
    },
  ];

  Widget _offsetPopup() => PopupMenuButton<int>(
      offset: const Offset(0, -90),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text(
                "Add New Package",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Edit Package",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const PopupMenuItem(
              value: 3,
              child: Text(
                "Remove Package",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
          ],
      icon: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: StadiumBorder(
                // side: BorderSide(color: Colors.white, width: 2),
                )),
        child: const Icon(Icons.menu_rounded, size: 26, color: Colors.white),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          // header
          AdminHeader(pageTitle: "MANAGE PACKAGE"),

          // Body content
          // Items
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: 570,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: gridData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (130 / 150),
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 14.0,
              ),
              itemBuilder: (context, index) {
                return CustomGridItem(
                  title: gridData[index]['title'],
                  imageUrl: gridData[index]['imageUrl'],
                  description: gridData[index]['description'],
                  price: gridData[index]['price'],
                );
              },
            ),
          ),
        ],
      )),
      bottomNavigationBar: AdminBottomNavBar(
        activePage: 2,
        role: role,
      ),
      floatingActionButton: SizedBox(
          height: 70,
          width: 70,

          // padding: EdgeInsets.only(right: 10.0, bottom: 1.0),
          child: _offsetPopup()),
    );
  }
}

class CustomGridItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final int price;

  const CustomGridItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.description,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0, color: Colors.transparent),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 120,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(
            height: 2,
          ),
          Text("Started from RM$price",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
