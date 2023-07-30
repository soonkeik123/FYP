// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ohmypet/controllers/location_controller.dart';
// import 'package:ohmypet/utils/colors.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late CameraPosition _cameraPosition;

//   @override
//   void initState() {
//     super.initState();
//     _cameraPosition = CameraPosition(
//         target: LatLng(1.5156854238821085, 103.68578661165871), zoom: 17);
//   }

//   late GoogleMapController _mapController;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (GoogleMapController mapController) {
//               _mapController = mapController;
//             },
//             initialCameraPosition: _cameraPosition,
//           ),
//           Positioned(
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 height: 50,
//                 padding: EdgeInsets.symmetric(horizontal: 5),
//                 decoration: BoxDecoration(
//                     color: AppColors.themeColor,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 25,
//                     color: AppColors.mainColor,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Expanded(
//                       child: Text(
//                     '${LocationController.pickPlaceMark.name ?? ''}'
//                     '${LocationController.pickPlaceMark.locality ?? ''}'
//                     '${LocationController.pickPlaceMark.postalCode ?? ''}'
//                     '${LocationController.pickPlaceMark.country ?? ''}',
//                     style: TextStyle(fontSize: 20),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   )),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Icon(
//                     Icons.search,
//                     size: 25,
//                     color: AppColors.mainColor,
//                   )
//                 ]),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
