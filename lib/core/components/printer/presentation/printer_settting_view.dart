import 'package:bastoga/core/components/custom_selected_container.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../mdsoft_printer.dart';

class PrinterSettingScreen extends StatelessWidget {
  const PrinterSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MdsoftPrinter.checkBluetoothState(wantGetBluetooth: true);

    return BlocProvider(
      create: (context) => BluetoothCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(surfaceTintColor: Colors.transparent, title: const Text("اعدادات الطابعه")),
        body: BlocBuilder<BluetoothCubit, BluetoothStates>(
          builder: (context, state) {
            final cubit = BlocProvider.of<BluetoothCubit>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(height: context.screenHeight * 0.05),
                  const Text(
                    "مقاس الورقة : ",
                    style: TextStyle(
                      fontFamily: "Regular",
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: BlocBuilder<BluetoothCubit, BluetoothStates>(
                          builder: (context, state) {
                            return PopupMenuButton<int>(
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(value: 1, child: Text("Paper 58")),
                                    const PopupMenuItem(value: 2, child: Text("Paper 80")),
                                  ],
                              offset: const Offset(0, 50),
                              color: Colors.white,
                              elevation: 3,
                              initialValue: cubit.selectedValue,
                              onSelected: (value) {
                                cubit.onSelectedPaper(value);
                              },
                              child: CustomSelectedContainer(
                                text:
                                    cubit.cubitCachingPaperSize == PrinterPaperSize.paper58
                                        ? "Paper 58"
                                        : "Paper 80",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  BlocBuilder<BluetoothCubit, BluetoothStates>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          const Text(
                            "اختر الطابعة : ",
                            style: TextStyle(
                              fontFamily: "Regular",
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          cubit.isConnectLoading
                              ? const DefaultSmallCircleIndicator()
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<BluetoothCubit, BluetoothStates>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Flexible(
                            child: PopupMenuButton<int>(
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(value: 1, child: Text("Sunmi")),
                                    ...List.generate(
                                      MdsoftPrinter.availableBluetoothDevices.isNotEmpty
                                          ? MdsoftPrinter.availableBluetoothDevices.length
                                          : 0,
                                      (index) => PopupMenuItem(
                                        value: index + 2,
                                        child: Builder(
                                          builder: (context) {
                                            String deviceInfo =
                                                MdsoftPrinter.availableBluetoothDevices[index];
                                            List<String> list = deviceInfo.split("#");
                                            String mac = list[1];

                                            return ListTile(
                                              onTap: () {
                                                cubit.changeIsConnectTrueLoading();
                                                MdsoftPrinter.setConnect(
                                                  mac,
                                                  deviceInfo.split("#")[0],
                                                ).whenComplete(() {
                                                  cubit.onSelectedBluetoothPrinter(
                                                    printer: deviceInfo.split("#")[0],
                                                  );
                                                  cubit.changeIsConnectFalseLoading();
                                                });
                                              },
                                              title: SizedBox(
                                                child: Text(deviceInfo.split("#")[0]),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                              offset: const Offset(0, 50),
                              color: Colors.white,
                              elevation: 3,
                              onSelected: (value) {
                                if (value == 1) {
                                  cubit.onSelectedSunmiPrinter();
                                }
                              },
                              child: CustomSelectedContainer(text: cubit.cubitCachingPrinter),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
