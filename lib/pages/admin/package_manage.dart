import 'package:firebase_database/firebase_database.dart';
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
  // Create a reference to Firebase database
  late DatabaseReference profileRef;

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

  List<GlobalKey> itemKeys = [];

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
                final GlobalKey itemKey = GlobalKey();
                itemKeys.add(itemKey);
                final packageItem = gridData[index];
                return GestureDetector(
                  onLongPress: () =>
                      _showLongPressOptions(context, index, itemKey),
                  child: PackageItem(
                    key: itemKey,
                    title: packageItem['title'],
                    imageUrl: packageItem['imageUrl'],
                    description: packageItem['description'],
                    price: packageItem['price'],
                  ),
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

  void _removePackage(int index) {
    setState(() {
      gridData.removeAt(index);
    });
  }

  void _showLongPressOptions(
      BuildContext context, int index, GlobalKey itemKey) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox widgetRenderBox =
        itemKey.currentContext?.findRenderObject() as RenderBox;

    if (widgetRenderBox != null) {
      final Offset tapPosition = widgetRenderBox.localToGlobal(Offset.zero);
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(tapPosition, tapPosition),
        Offset(10, 0) & overlay.size,
      );

      showMenu(
        context: context,
        position: position,
        items: [
          PopupMenuItem(
            value: 'edit',
            child: Text('Edit Package'),
          ),
          PopupMenuItem(
            value: 'remove',
            child: Text('Remove Package'),
          ),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == 'edit') {
          // Handle Edit Package action
        } else if (value == 'remove') {
          // Handle Remove Package action
        }
      });
    }
  }
}

class PackageItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final int price;

  const PackageItem(
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
