import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/add_package.dart';
import 'package:ohmypet/pages/admin/edit_package.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/admin_navigation_bar.dart';

import '../../utils/colors.dart';

class PackageManagement extends StatefulWidget {
  static const routeName = '/packageManagement';
  final String role;
  const PackageManagement({super.key, required this.role});

  @override
  State<PackageManagement> createState() => _PackageManagementState();
}

class _PackageManagementState extends State<PackageManagement> {
  // Create a reference to Firebase database
  late DatabaseReference packageRef;

  late String role;
  String packageTitle = '';
  String packageDescription = '';
  String packagePrice = '';
  String packageImageUrl = '';

  @override
  void initState() {
    super.initState();

    packageRef = FirebaseDatabase.instance.ref('packages');
    getPackageInfo();

    role = widget.role;
  }

  void refreshData() {
    setState(() {
      getPackageInfo();
    });
  }

  late List<Map> gridData = [];
  late List<String> gridDataID = [];

  Widget _offsetPopup() => PopupMenuButton<int>(
      onSelected: (value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddPackagePage()));
      },
      offset: const Offset(0, -40),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text(
                "Add New Package",
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
        child:
            const Icon(Icons.add_circle_outline, size: 26, color: Colors.white),
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
          const AdminHeader(pageTitle: "MANAGE PACKAGE"),

          // Body content
          // Items
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.8,
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

                return GestureDetector(
                  onLongPress: () =>
                      _showLongPressOptions(context, index, itemKey),
                  onTap: () => _showPackageDetail(context, index, itemKey),
                  child: PackageItem(
                    key: itemKey,
                    title: gridData[index]['title'],
                    imageUrl: gridData[index]['imageUrl'],
                    description: gridData[index]['description'],
                    price: double.parse(gridData[index]['price']),
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

  void _showLongPressOptions(
      BuildContext context, int index, GlobalKey itemKey) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox widgetRenderBox =
        itemKey.currentContext?.findRenderObject() as RenderBox;

    final Offset tapPosition = widgetRenderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(tapPosition, tapPosition),
      const Offset(10, 0) & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit Package'),
        ),
        const PopupMenuItem(
          value: 'remove',
          child: Text('Remove Package'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'edit') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditPackagePage(packageID: gridDataID[index])));
      } else if (value == 'remove') {
        removeConfirmationDialog(context, gridDataID[index], index);
      }
    });
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
                  File(gridData[index]['imageUrl']),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  gridData[index]['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  gridData[index]['description'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: RM ${gridData[index]['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Services: ${gridData[index]['grooming']}, ${gridData[index]['boarding']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditPackagePage(
                                      packageID: gridDataID[index])));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Set the button color to orange
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Add some spacing between the buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          removeConfirmationDialog(
                              context, gridDataID[index], index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Set the button color to red
                        ),
                        child: const Text('Remove'),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the "Close" button action here
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

  // Confirm Remove Action
  void removeConfirmationDialog(BuildContext context, String pid, index) {
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
          content: const SizedBox(
            height: 50,
            child: Text('Are you sure you want to remove this package ?'),
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
        packageRef = FirebaseDatabase.instance.ref('packages/$pid');

        packageRef.update({
          'delete': true,
        }).then((value) => print("Package deleted"));
      } else {}
    });
  }

  void getPackageInfo() {
    try {
      // // Get a reference to the 'packages' node in the Realtime Database
      DatabaseReference packageRef =
          FirebaseDatabase.instance.ref().child('packages');

      // Query the 'packages' node to get package data
      Query packageQuery = packageRef;

      // Listen for the value event
      packageQuery.onValue.listen((DatabaseEvent event) {
        // Access the DataSnapshot from the event
        DataSnapshot snapshot = event.snapshot;

        // Check if the snapshot's value is not null and is of type Map<dynamic, dynamic>
        if (snapshot.value != null) {
          // Convert the value to a Map<dynamic, dynamic>
          Map<dynamic, dynamic> packageItem = snapshot.value as Map;
          gridData.clear();
          // Loop through the snapshot's children (admin users)
          packageItem.forEach((key, packageData) {
            // check if the packages are deleted
            if (!packageData['delete']) {
              setState(() {
                gridData.add(packageData);
                gridDataID.add(key);
              });
            }
          });
        }
      });
    } catch (e) {
      print('Error getting admin users: $e');
    }
  }
}

class PackageItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;

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
            height: 130,
            child: Image.file(
              File(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 2,
          ),
          Text("Started from RM${price.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
