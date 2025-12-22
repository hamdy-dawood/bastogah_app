import 'package:bastoga/core/components/add_button_with_text.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/location_services.dart';

class RouteTrackerAppMap extends StatefulWidget {
  const RouteTrackerAppMap({super.key, required this.blocContext});

  final BuildContext blocContext;

  @override
  State<RouteTrackerAppMap> createState() => _RouteTrackerAppMapState();
}

class _RouteTrackerAppMapState extends State<RouteTrackerAppMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late LocationService locationService;
  Set<Marker> markers = {};
  LatLng? selectedLocation;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(33.312805, 44.361488), zoom: 14);
    locationService = LocationService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.blocContext.read<MerchantProductsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text("تحديد الموقع"),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: context.screenHeight,
              width: context.screenWidth,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                onMapCreated: (controller) {
                  googleMapController = controller;
                },
                onTap: (LatLng position) {
                  setState(() {
                    selectedLocation = position;
                    markers.clear(); // Clear existing markers
                    markers.add(
                      Marker(markerId: const MarkerId("selected_marker"), position: position),
                    );
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AddButtonWithTextIcon(
                  buttonText: "  تحديد  ",
                  icon: ImageManager.location,
                  onTap: () {
                    if (selectedLocation != null) {
                      debugPrint(
                        "Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}",
                      );

                      widget.blocContext.read<MerchantProductsCubit>().changeLocation(
                        selectedLatitude: selectedLocation!.latitude,
                        selectedLongitude: selectedLocation!.longitude,
                      );
                      context.pop();
                    } else {
                      showDefaultFlushBar(
                        context: context,
                        color: AppColors.redE7,
                        messageText: "من فضلك حدد الموقع",
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
