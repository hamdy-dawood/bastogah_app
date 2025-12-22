// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher_string.dart';
//
// import '../../../../../../core/utils/colors.dart';
// import '../../../../client_version/my_orders/domain/entities/orders.dart';
//
// class MerchantLocationScreen extends StatelessWidget {
//   final MerchantLocation merchantLocation;
//
//   const MerchantLocationScreen({
//     super.key,
//     required this.merchantLocation,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       body: GoogleMap(
//         myLocationEnabled: false,
//         myLocationButtonEnabled: true,
//         zoomControlsEnabled: true,
//         buildingsEnabled: true,
//         // onTap: (argument) {
//         //   // draw new marker
//         //   ApartmentsCubit.of(context).changeMarkerPosition(
//         //     latitude: argument.latitude,
//         //     longitude: argument.longitude,
//         //   );
//         //
//         //   selectedArgument = argument;
//         // },
//         markers: {
//           Marker(
//             markerId: const MarkerId('0'),
//             position: LatLng(
//               merchantLocation.coordinates.last,
//               merchantLocation.coordinates.first,
//             ),
//           ),
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             merchantLocation.coordinates.last,
//             merchantLocation.coordinates.first,
//           ),
//           zoom: 14,
//         ),
//         // onMapCreated: (GoogleMapController controller) {
//         //   gMapController = controller;
//         // },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.defaultColor,
//         child: const Icon(
//           Icons.map_sharp,
//         ),
//         pressed: () {
//           launchUrlString(
//             "geo:${merchantLocation.coordinates.last},${merchantLocation.coordinates.first}?q=${merchantLocation.coordinates.last},${merchantLocation.coordinates.first}",
//             // 'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lang}',
//             mode: LaunchMode.externalApplication,
//           );
//         },
//       ),
//     );
//   }
// }
