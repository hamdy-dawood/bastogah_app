import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mdsoft_printer.dart';
import 'states.dart';

class BluetoothCubit extends Cubit<BluetoothStates> {
  BluetoothCubit() : super(BluetoothInitialState());

  int selectedValue = 1;
  int xIndex = 0;

  String cubitCachingPrinter = cachingPrinter;
  PrinterPaperSize? cubitCachingPaperSize;

  void onSelectedPaper(int value) {
    selectedValue = value;
    if (value == 1) {
      cubitCachingPaperSize = PrinterPaperSize.paper58;
      Caching.savePaperSize(cubitCachingPaperSize!);
    } else if (value == 2) {
      cubitCachingPaperSize = PrinterPaperSize.paper80;
      Caching.savePaperSize(cubitCachingPaperSize!);
    }
    emit(ChangeSelectedPaperState());
  }

  void onSelectedSunmiPrinter() {
    cachingPrinter = "Sunmi";
    cubitCachingPrinter = cachingPrinter;
    cubitCachingPaperSize = PrinterPaperSize.paper58;
    Caching.saveData(key: "printer", value: cubitCachingPrinter);
    Caching.savePaperSize(cubitCachingPaperSize!);
    emit(SelectedSunmiPrinterState());
  }

  void onSelectedBluetoothPrinter({required String printer}) {
    cachingPrinter = printer;
    cubitCachingPrinter = cachingPrinter;
    emit(SelectedBluetoothPrinterState());
  }

  // =================================================================

  bool isPrintLoading = false;

  void changeIsPrintTrueLoading() {
    isPrintLoading = true;
    emit(ChangeIsPrintLoadingState());
  }

  void changeIsPrintFalseLoading() {
    isPrintLoading = false;
    emit(ChangeIsPrintLoadingState());
  }

  // =================================================================

  bool isConnectLoading = false;

  void changeIsConnectTrueLoading() {
    isConnectLoading = true;
    emit(ChangeIsConnectLoadingState());
  }

  void changeIsConnectFalseLoading() {
    isConnectLoading = false;
    emit(ChangeIsConnectLoadingState());
  }
}
