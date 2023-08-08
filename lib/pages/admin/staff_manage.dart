import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  // Create a reference to Firebase database
  late DatabaseReference adminRef;

  late String role;
  String staffName = '';
  String staffEmail = '';
  String staffPhone = '';

  String currentAdminName = '';
  String currentAdminID = '';

  late List<Map> staff;
  late List<Map> admin;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    adminRef = FirebaseDatabase.instance.ref().child('users');

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentAdminID = user.uid;
    }

    role = widget.role;
    getStaffAndAdminUsers();
    super.initState();
  }

  void refreshPage() {
    setState(() {
      staff = filterOrdersByStatus(staffData, "staff");
      admin = filterOrdersByStatus(staffData, "admin");
    });
  }

  List<Map> staffData = [];

  Future<void> getStaffAndAdminUsers() async {
    try {
      // Get a reference to the 'users' node in the Realtime Database
      DatabaseReference adminRef =
          FirebaseDatabase.instance.ref().child('staffs');

      // Listen for the value event
      adminRef.onValue.listen((DatabaseEvent event) {
        // Access the DataSnapshot from the event
        DataSnapshot snapshot = event.snapshot;

        // Check if the snapshot's value is not null and is of type Map<dynamic, dynamic>
        if (snapshot.value != null) {
          // Convert the value to a Map<dynamic, dynamic>
          Map<dynamic, dynamic> adminStaffs =
              snapshot.value as Map<dynamic, dynamic>;
          staffData.clear();
          // print(adminUsers); // Checking purpose
          // Loop through the snapshot's children (admin users)
          adminStaffs.forEach((key, staffsData) {
            final staffProfile = staffsData['Profile'];
            if (staffProfile['role'] == 'admin' ||
                staffProfile['role'] == 'staff') {
              staffData.add(staffProfile);
            }
            if (key == currentAdminID) {
              currentAdminName = staffProfile['full_name'];
            }
          });
          refreshPage();
          // print(staffData.toList());
        }
      });
    } catch (e) {
      print('Error getting admin users: $e');
    }
  }

  List<Map> filterOrdersByStatus(List<Map> orders, String status) {
    return orders.where((order) => order["role"] == status).toList();
  }

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

  // ADD NEW MEMBER
  void _showTopSheet(BuildContext context, String newRole) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 50.0), // Adjust the top padding to move the dialog down
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: const Text(
              'Add Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: nameController,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    controller: phoneController,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: emailController,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      bool isAllFilled = true;

                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        isAllFilled = false;
                      }
                      if (isAllFilled) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: _passwordController.text)
                            .then((value) async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String uid = user.uid;
                            // Now you have the UID of the current user

                            DatabaseReference profileRef = FirebaseDatabase
                                .instance
                                .ref()
                                .child('staffs')
                                .child(uid)
                                .child('Profile');

                            Map<String, dynamic> profileData = {
                              'full_name': nameController.text,
                              'email': emailController.text,
                              'phone': '6${phoneController.text}',
                              'role': newRole,
                            };

                            profileRef.set(profileData).then((_) {
                              // Clear data
                              Clear();
                              print('Data saved successfully!');
                              showMessageDialog(context, "ADD SUCCESSFUL",
                                  "You have added a new member successfully!");
                            }).catchError((error) {
                              print('Error saving data: $error');
                            });
                          }
                          Navigator.pop(context); // Close the top sheet
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _editStaffInfo(BuildContext context, String name) async {
    TextEditingController editNameController = TextEditingController();
    TextEditingController editPhoneController = TextEditingController();
    TextEditingController editEmailController = TextEditingController();
    _passwordController.clear();

    final DatabaseReference adminRef = FirebaseDatabase.instance.ref();
    String uid = '';

    // Query the 'Profile' node to get admin users
    Query adminQuery = adminRef.child('staffs');

    // Listen for the value event
    adminQuery.onValue.listen((DatabaseEvent event) {
      // Access the DataSnapshot from the event
      DataSnapshot snapshot = event.snapshot;
      // Check if the snapshot's value is not null and is of type Map<dynamic, dynamic>
      if (snapshot.value != null) {
        // Convert the value to a Map<dynamic, dynamic>
        Map<dynamic, dynamic> adminStaffs =
            snapshot.value as Map<dynamic, dynamic>;
        // Loop through the snapshot's children (admin users)
        adminStaffs.forEach((key, staffsData) async {
          if (staffsData['Profile']['full_name'] == name) {
            setState(() {
              uid = key;
            });
            final snapshot = await adminRef.child('staffs/$uid').get();

            if (snapshot.exists) {
              if (staffsData != null) {
                Map<dynamic, dynamic> profileData =
                    staffsData['Profile'] as Map;
                // Record the original data to compare if changed
                staffName = profileData['full_name'] ?? '';
                staffPhone = profileData['phone'] ?? '';
                staffEmail = profileData['email'] ?? '';

                editNameController.text = profileData['full_name'] ?? '';
                editPhoneController.text = profileData['phone'] ?? '';
                editEmailController.text = profileData['email'] ?? '';
              } else {
                print("User not found or missing Profile data.");
              }
            } else {
              print("No data available.");
            }
          }
        });
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 50.0), // Adjust the top padding to move the dialog down
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: editNameController,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    controller: editPhoneController,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: editEmailController,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      bool isAllFilled = true;

                      if (editNameController.text.isEmpty ||
                          editPhoneController.text.isEmpty ||
                          editEmailController.text.isEmpty) {
                        isAllFilled = false;
                      }
                      if (isAllFilled) {
                        bool name = (staffName != editNameController.text);
                        bool phone = (staffPhone != editPhoneController.text);
                        bool email = (staffEmail != editEmailController.text);

                        DatabaseReference profileRef = FirebaseDatabase.instance
                            .ref('staffs/$uid')
                            .child('Profile');

                        Map<String, dynamic> staffData = {
                          if (name) 'full_name': editNameController.text,
                          if (email) 'email': editEmailController.text,
                          if (phone) 'phone': editPhoneController.text,
                        };

                        profileRef.update(staffData).then((_) {
                          showMessageDialog(context, "EDIT SUCCESSFUL",
                              "You have edited this staff's information");
                          print('Data saved successfully!');
                          Navigator.pop(context);
                        }).catchError((error) {
                          print('Error saving data: $error');
                        });

                        Navigator.pop(context); // Close the top sheet
                      } else {
                        showMessageDialog(
                            context,
                            "Please Fill Up All Form Fields",
                            "Please make sure to fill up all the required form fields.");
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
      // padding: const EdgeInsets.only(bottom: 2),
      offset: const Offset(-15, -70),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text(
                "Add New Staff",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Add Administrator",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
          ],
      onSelected: (value) {
        if (value == 1) {
          _showTopSheet(context, "staff");
        } else if (value == 2) {
          _showTopSheet(context, "admin");
        }
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
    List<Map> staff = filterOrdersByStatus(staffData, "staff");
    List<Map> admin = filterOrdersByStatus(staffData, "admin");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const AdminHeader(pageTitle: "MANAGE STAFF"),

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
                          return Dismissible(
                            key: Key(admin[index]['email']),
                            direction: DismissDirection.horizontal,

                            // On confirming
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                _editStaffInfo(
                                    context, admin[index]['full_name']);
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                return showConfirmationDialog(context)
                                    .then((confirmDelete) {
                                  if (confirmDelete == true) {
                                    if (admin[index]['full_name'] ==
                                        currentAdminName) {
                                      showMessageDialog(
                                          context,
                                          "Fail to Remove",
                                          "You cannot delete your account by yourself.");
                                    } else {
                                      removeStaff(admin[index]['full_name']);
                                    }
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
                              name: admin[index]["full_name"],
                              email: admin[index]["email"],
                              phone: admin[index]["phone"],
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
                            return Dismissible(
                              direction: DismissDirection.horizontal,

                              // On confirming
                              confirmDismiss: (direction) async {
                                // Edit
                                if (direction == DismissDirection.startToEnd) {
                                  _editStaffInfo(
                                      context, staff[index]['full_name']);

                                  // Delete
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  return showConfirmationDialog(context)
                                      .then((confirmDelete) {
                                    if (confirmDelete == true) {
                                      removeStaff(staff[index]['full_name']);
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
                              key: Key(staff[index]['email']),
                              child: staffItemWidget(
                                name: staff[index]["full_name"],
                                email: staff[index]["email"],
                                phone: staff[index]["phone"],
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

  void removeStaff(String adminRemove) {
    // Query the 'Profile' node to get admin users
    Query adminQuery = adminRef;

    // Listen for the value event
    adminQuery.onValue.listen((DatabaseEvent event) {
      // Access the DataSnapshot from the event
      DataSnapshot snapshot = event.snapshot;

      // Check if the snapshot's value is not null and is of type Map<dynamic, dynamic>
      if (snapshot.value != null) {
        // Convert the value to a Map<dynamic, dynamic>
        Map<dynamic, dynamic> adminUsers =
            snapshot.value as Map<dynamic, dynamic>;
        // Loop through the snapshot's children (admin users)
        adminUsers.forEach((key, userData) {
          if (userData['Profile']['full_name'] == adminRemove) {
            FirebaseDatabase.instance.ref('users/$key').remove();

            // Unable to remove user from Authentication easily
          }
        });

        // print(staffData.toList());
      }
    });
  }

  void Clear() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    _passwordController.clear();
  }
}

void showMessageDialog(
    BuildContext context, String titleText, String contentText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class staffItemWidget extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const staffItemWidget({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
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
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 19,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Phone: +$phone",
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
