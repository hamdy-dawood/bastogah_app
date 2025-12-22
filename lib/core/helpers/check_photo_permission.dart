// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CheckPhotoPermission {
//   static Future<bool> checkPermission() async {
//     var status = await Permission.storage.status;
//     final deviceInfo = await DeviceInfoPlugin().androidInfo;
//
//     if (deviceInfo.version.sdkInt > 32) {
//       if (status.isDenied) {
//         if (await Permission.photos.request().isGranted) {
//           return true;
//         } else {
//           return false;
//         }
//       } else if (status.isPermanentlyDenied) {
//         openAppSettings();
//         return false;
//       }
//     } else {
//       if (status.isDenied) {
//         if (await Permission.storage.request().isGranted) {
//           return true;
//         } else {
//           return false;
//         }
//       } else if (status.isPermanentlyDenied) {
//         openAppSettings();
//         return false;
//       }
//     }
//
//     return true;
//   }
// }
