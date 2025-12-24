import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/utils/colors.dart';
import '../cubit/client_home_cubit.dart';

class OrderMapsScreen extends StatefulWidget {
  final BuildContext oldContext;

  const OrderMapsScreen({super.key, required this.oldContext});

  @override
  State<OrderMapsScreen> createState() => _OrderMapsScreenState();
}

class _OrderMapsScreenState extends State<OrderMapsScreen> {
  @override
  void initState() {
    if (widget.oldContext.read<ClientHomeCubit>().selectedLng == null) {
      widget.oldContext.read<ClientHomeCubit>().checkLocationService();
    }
    super.initState();
  }

  GoogleMapController? gMapController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.oldContext.read<ClientHomeCubit>(),
      child: BlocBuilder<ClientHomeCubit, ClientHomeStates>(
        builder: (context, state) {
          return Scaffold(
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.check)),
              //   backgroundColor: Colors.transparent,
            ),
            body:
                context.read<ClientHomeCubit>().devicePosition != null
                    ? GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      buildingsEnabled: true,
                      onTap: (argument) {
                        // draw new marker
                        context.read<ClientHomeCubit>().changeMarkerPosition(
                          latitude: argument.latitude,
                          longitude: argument.longitude,
                        );
                      },
                      markers: context.read<ClientHomeCubit>().markers.toSet(),
                      initialCameraPosition: CameraPosition(
                        target:
                            context.read<ClientHomeCubit>().selectedLng != null
                                ? LatLng(
                                  context.read<ClientHomeCubit>().selectedLat!,
                                  context.read<ClientHomeCubit>().selectedLng!,
                                )
                                : LatLng(
                                  context.read<ClientHomeCubit>().devicePosition!.latitude,
                                  context.read<ClientHomeCubit>().devicePosition!.longitude,
                                ),
                        zoom: 14,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        gMapController = controller;
                      },
                    )
                    : const Center(child: CircularProgressIndicator(color: AppColors.defaultColor)),
          );
        },
      ),
    );
  }
}
