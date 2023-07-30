import 'package:flutter/material.dart';
import 'package:ohmypet/widgets/admin_header.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_bar.dart';
import '../../widgets/title_text.dart';

class StaffManagement extends StatefulWidget {
  static const routeName = '/staffManagement';
  final String role;
  const StaffManagement({super.key, required this.role});

  @override
  State<StaffManagement> createState() => _StaffManagementState();
}

class _StaffManagementState extends State<StaffManagement> {
  late String role;

  @override
  void initState() {
    super.initState();

    role = widget.role;
    // fetchData();
  }

  void refreshPage() {
    print("Got iittt");
  }

  List<Map<String, dynamic>> staffData = [
    {
      "id": 1,
      "name": "NG MENG HUI",
      "email": "hunter@gmail.com",
      "role": "admin",
      "create_date": "2023-07-20"
    },
    {
      "id": 2,
      "name": "John Doe",
      "email": "johndoe@example.com",
      "role": "staff",
      "create_date": "2023-07-21"
    },
    {
      "id": 3,
      "name": "Jane Smith",
      "email": "janesmith@example.com",
      "role": "staff",
      "create_date": "2023-07-22"
    },
    {
      "id": 4,
      "name": "Michael Lee",
      "email": "michaellee@example.com",
      "role": "staff",
      "create_date": "2023-07-23"
    },
    {
      "id": 5,
      "name": "Emily Tan",
      "email": "emilytan@example.com",
      "role": "staff",
      "create_date": "2023-07-24"
    },
  ];

  List<Map<String, dynamic>> filterOrdersByStatus(
      List<Map<String, dynamic>> orders, String status) {
    return orders.where((order) => order["role"] == status).toList();
  }

  // Future<void> fetchData() async {
  //   await Future.delayed(Duration(seconds: 2)); // Simulating async fetch
  //   // Once data is available, update the orders list
  //   setState(() {
  //     orders = [
  //       Order(
  //         id: '#001',
  //         status: 'Processing',
  //         serviceName: 'Pet Grooming',
  //         date: '2023-07-20',
  //         time: '10:00 AM',
  //       ),
  //       Order(
  //         id: '#002',
  //         status: 'Incoming',
  //         serviceName: 'Pet Boarding',
  //         date: '2023-07-21',
  //         time: '12:00 PM',
  //       ),
  //     ];
  //   });
  // }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false to cancel the delete action
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true to proceed with the delete action
              },
            ),
          ],
        );
      },
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
      // padding: const EdgeInsets.only(bottom: 2),
      offset: const Offset(0, -70),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text(
                "Add New Member",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Edit Staff",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const PopupMenuItem(
              value: 3,
              child: Text(
                "Remove Member",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
          ],
      onSelected: (value) {
        setState(() {});
      },
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
    List<Map<String, dynamic>> staff = filterOrdersByStatus(staffData, "staff");
    List<Map<String, dynamic>> admin = filterOrdersByStatus(staffData, "admin");
    List<int> dismissedItemIds = [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          AdminHeader(pageTitle: "MANAGE STAFF"),

          // Body
          Expanded(
            child: Container(
              height: double.maxFinite,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "ADMIN",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mainColor),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black45, width: 0.5)),
                    ),

                    // ADMIN
                    SizedBox(
                      width: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: admin.length,
                        itemBuilder: (context, index) {
                          // Display processing orders
                          // return staffItemWidget(
                          //   id: admin[index]['id'],
                          //   name: admin[index]["name"],
                          //   email: admin[index]["email"],
                          //   createDate: admin[index]["create_date"],
                          // );

                          return Dismissible(
                            key: Key(admin[index]['id'].toString()),
                            direction: DismissDirection.horizontal,

                            // On confirming
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                Navigator.pushNamed(
                                    context, '/packageManagement');
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                // Show a delete dialog or prompt to delete
                                // Return true to allow the action, false to cancel it
                                return showConfirmationDialog(context)
                                    .then((confirmDelete) {
                                  if (confirmDelete == true) {
                                    staff.remove(index);
                                    refreshPage();
                                  } else {}
                                  return null;
                                });
                              }
                              return null;
                            },

                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.blue,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.red,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ),
                            child: staffItemWidget(
                              id: admin[index]['id'],
                              name: admin[index]["name"],
                              email: admin[index]["email"],
                              createDate: admin[index]["create_date"],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    TitleText(
                      text: "STAFF",
                      size: 23,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black45, width: 0.5)),
                    ),

                    // STAFF MEMBER
                    SizedBox(
                        width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: staff.length,
                          itemBuilder: (context, index) {
                            // Display processing orders
                            // return staffItemWidget(
                            //   id: staff[index]['id'],
                            //   name: staff[index]["name"],
                            //   email: staff[index]["email"],
                            //   createDate: staff[index]["create_date"],
                            // );

                            return Dismissible(
                              key: Key(staff[index]['id'].toString()),
                              direction: DismissDirection.horizontal,

                              // On confirming
                              confirmDismiss: (direction) async {
                                // Edit
                                if (direction == DismissDirection.startToEnd) {
                                  Navigator.pushNamed(
                                      context, '/packageManagement');

                                  // Delete
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  return showConfirmationDialog(context)
                                      .then((confirmDelete) {
                                    if (confirmDelete == true) {
                                      staff.remove(index);
                                    } else {
                                      // Cancel the delete action
                                      // You may want to update the list to show the item again
                                    }
                                    return null;
                                  });
                                }
                                return null;
                              },

                              background: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.blue,
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(Icons.edit),
                                  ),
                                ),
                              ),
                              secondaryBackground: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.red,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                              ),
                              child: staffItemWidget(
                                id: staff[index]['id'],
                                name: staff[index]["name"],
                                email: staff[index]["email"],
                                createDate: staff[index]["create_date"],
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: AdminBottomNavBar(activePage: 3, role: role),
      floatingActionButton:
          SizedBox(height: 70, width: 70, child: _offsetPopup()),
    );
  }
}

class staffItemWidget extends StatelessWidget {
  final int id;
  final String name;
  final String email;
  final String createDate;

  const staffItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.createDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0.5),
                  blurRadius: 1,
                  spreadRadius: 0.5)
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile Icon
              const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.person,
                  color: AppColors.mainColor,
                  size: 50,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // Information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 19,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '#$id',
                        style: const TextStyle(
                            fontSize: 19,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Since $createDate",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          )),
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TrackProgressPage(reservationID: id)));
      },
    );
  }
}
