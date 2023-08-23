import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

class SelectRoomPage extends StatefulWidget {
  static const selectDogRoom = '/selectDogRoom';
  static const selectCatRoom = '/selectCatRoom';
  String petSize;
  bool dogBoard;
  bool package;
  SelectRoomPage(
      {super.key,
      required this.dogBoard,
      required this.petSize,
      required this.package});

  @override
  State<SelectRoomPage> createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  PageController pageController = PageController(
      viewportFraction: 0.85); // Decide the space between each slide

  late bool isDog;
  late String petSize = '';

  List<String> packageRoomPrice = [
    'No Additional Price',
    'Additional RM 10',
    'Additional RM 20'
  ];

  List<Map<String, dynamic>> boardingList = [
    {
      'type': 'Cat Boarding',
      'rooms': ['C1', 'C2', 'C3'],
      'names': ['General Room', 'Deluxe Room', 'Superior Room'],
      'imageURL': [
        'assets/images/cat-cage-2.png',
        'assets/images/cat-cage-1.png',
        'assets/images/cat-cage-3.png',
      ],
      'small_medium': [
        'RM 50 per Night',
        'RM 60 per Night',
        'RM 70 per Night',
      ],
      'large_giant': [
        'RM 60 per Night',
        'RM 70 per Night',
        'RM 80 per Night',
      ],
    },
    {
      'type': 'Dog Boarding',
      'rooms': ['D1', 'D2', 'D3'],
      'names': ['General Room', 'Deluxe Room', 'Superior Room'],
      'imageURL': [
        'assets/images/dog-cage-1.png',
        'assets/images/dog-cage-2.png',
        'assets/images/dog-cage-3.png',
      ],
      'small_medium': [
        'RM 50 per Night',
        'RM 60 per Night',
        'RM 70 per Night',
      ],
      'large_giant': [
        'RM 60 per Night',
        'RM 70 per Night',
        'RM 80 per Night',
      ],
    },
  ];

  @override
  void initState() {
    // print("actual size = ${Dimensions.screenHeight}");
    isDog = widget.dogBoard;
    setState(() {
      petSize = widget.petSize;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    // dispose the unnecessary data from initState() to keep memory used small
  }

  // Room Selection
  String roomSelected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          // Header
          const CustomHeader(
            pageTitle: "Make Reservation",
          ),

          Stack(
            children: [
              // Header Text
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "Select Your Pet's Room:",
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              // Content
              Align(
                  alignment: Alignment.center,
                  heightFactor: 1.25,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.maxFinite,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Slider for room
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 370,
                            child: PageView.builder(
                                controller: pageController,
                                itemCount: 3,
                                itemBuilder: (context, position) {
                                  return _buildPageItem(position);
                                }),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(int index) {
    return Container(
      child: Column(children: [
        //image
        Container(
          height: 220,
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: isDog
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(boardingList[1]['imageURL'][index]))
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(boardingList[0]['imageURL'][index])),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              isDog
                  ? TitleText(text: boardingList[1]['rooms'][index])
                  : TitleText(text: boardingList[0]['rooms'][index]),
              const SizedBox(
                height: 2,
              ),
              isDog
                  ? TitleText(text: boardingList[1]['names'][index])
                  : TitleText(text: boardingList[0]['names'][index]),
              const SizedBox(
                height: 5,
              ),
              widget.package
                  ? SmallText(
                      text: packageRoomPrice[index],
                      size: 17,
                      color: Colors.blue.shade600,
                    )
                  : SmallText(
                      text: isDog
                          ? ((petSize == "Small" || petSize == "Medium")
                              ? boardingList[1]['small_medium'][index]
                              : boardingList[1]['large_giant'][index])
                          : ((petSize == "Small" || petSize == "Medium")
                              ? boardingList[0]['small_medium'][index]
                              : boardingList[0]['large_giant'][index]),
                      size: 17,
                      color: Colors.blue.shade600,
                    ),
              const SizedBox(
                height: 10,
              ),
              // Select Button
              InkWell(
                onTap: () {
                  isDog
                      ? setState(() {
                          roomSelected = boardingList[1]['rooms'][index];
                        })
                      : setState(() {
                          roomSelected = boardingList[0]['rooms'][index];
                        });
                  Navigator.pop(
                    context,
                    roomSelected, // Replace NewPage with the name of your new page class
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  height: 40,
                  width: 140,
                  child: BigText(
                    text: "Select",
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
