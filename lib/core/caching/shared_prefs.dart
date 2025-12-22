import 'package:bastoga/core/caching/local_favorite.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_cart.dart';

class Caching {
  static SharedPreferences? prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static saveData({required String key, required dynamic value}) async {
    if (value is int) return await prefs?.setInt(key, value);
    if (value is bool) return await prefs?.setBool(key, value);
    if (value is double) return await prefs?.setDouble(key, value);
    if (value is String) return await prefs?.setString(key, value);
  }

  static getData({required String key}) {
    return prefs?.get(key);
  }

  static removeData({required String key}) {
    return prefs?.remove(key);
  }

  static saveListString({required String key, required dynamic value}) async {
    return await prefs?.setStringList(key, value);
  }

  static getListString({required String key}) {
    return prefs?.getStringList(key);
  }

  static Future<void> savePaperSize(PrinterPaperSize model) async {
    await prefs?.setString("paper_size", model.toString());
  }

  static PrinterPaperSize? getPaperSize() {
    String? paperPref = prefs?.getString("paper_size");
    if (paperPref == null) {
      return null;
    }
    try {
      return PrinterPaperSize.values.firstWhere(
        (e) => e.toString() == paperPref,
        orElse: () => PrinterPaperSize.paper58,
      );
    } catch (e) {
      return PrinterPaperSize.paper58;
    }
  }

  static clearAllData() {
    cart.clear();
    favorite.clear();
    return prefs?.clear();
  }
}
