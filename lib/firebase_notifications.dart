import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/caching/shared_prefs.dart';
import 'core/utils/constance.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // _showLocalNotification(message); // Show local notification for background/terminated
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Access SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final isMerchant = prefs.getString(AppConstance.merchantCachedKey) != null;

  if (isMerchant) {
    print("================ ORDER IS IN BACKGROUND ================");
    // Future<bool> makeOrderInProgress({required String orderId}) async {
    //   bool printed = false;
    //
    //   await DioHelper.putData(
    //     baseUrl: AppApis.baseUrl,
    //     path: '${AppApis.orders}/$orderId',
    //     data: {
    //       "status": 1,
    //       "fcmType": 0,
    //     },
    //     headers: {
    //       "Authorization": Caching.getData(key: AppConstance.accessTokenKey),
    //     },
    //   ).then((response) {
    //     final status = response.data['status'];
    //     if (status == 'success') {
    //       printed = false;
    //     } else {
    //       // final errorMessage = response.data['message'];
    //       // print(errorMessage);
    //     }
    //   }).catchError((error) {
    //     // print(error);
    //   });
    //   return printed;
    // }
    //
    // bool isAutoPrintingEnabled = prefs.getBool("auto_printing") ?? false;
    // bool printingInProgress = false;
    //
    // void autoPrintOrders(List<Orders> orders) async {
    //   if (printingInProgress) {
    //     return;
    //   }
    //   printingInProgress = true;
    //
    //   List<Orders> allOrders = orders;
    //   List<Orders> ordersToPrint = allOrders.where((order) => order.status == 0).toList();
    //
    //   for (int i = ordersToPrint.length - 1; i >= 0; i--) {
    //     if (isAutoPrintingEnabled == false) {
    //       printingInProgress = false;
    //       return;
    //     }
    //
    //     String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    //     if (isConnected == "true") {
    //       var futures = [
    //         makeOrderInProgress(orderId: ordersToPrint[i].id),
    //         MdsoftPrinter.printBill(widget: BillDesign(order: ordersToPrint[i])),
    //       ];
    //       await Future.wait(futures);
    //     } else {
    //       String mac = Caching.getData(key: "printer_mac") ?? "";
    //       String printer = Caching.getData(key: "printer") ?? "Sunmi";
    //       //
    //       // if (mac.isEmpty) {
    //       //   context.pushNamed(
    //       //     Routes.printerScreen,
    //       //   );
    //       // } else {
    //       //   OverlayLoadingProgress.start(context);
    //       MdsoftPrinter.setConnect(mac, printer, reConnect: true).whenComplete(() {
    //         // OverlayLoadingProgress.stop();
    //       });
    //       // }
    //     }
    //   }
    //
    //   printingInProgress = false;
    // }
    //
    //
    //
    // final response = await DioHelper.getData(
    //   baseUrl: AppApis.baseUrl,
    //   path: AppApis.orders,
    //   headers: {
    //     "Authorization": Caching.getData(key: AppConstance.accessTokenKey),
    //   },
    //   query: {
    //     "skip": 0,
    //     "status": 0,
    //     "merchant": Caching.getData(key: AppConstance.loggedInUserKey),
    //   },
    // );
    //
    // if (response.statusCode == 200) {
    //   if (List<OrderModel>.from(
    //     response.data.map((e) => OrderModel.fromJson(e)),
    //   ).isNotEmpty) {
    //     // AudioPlayer().play(AssetSource('sounds/new_order.wav'));
    //     print("API FINISHED");
    //     if (isAutoPrintingEnabled) {
    //       autoPrintOrders(List<OrderModel>.from(
    //         response.data.map((e) => OrderModel.fromJson(e)),
    //       ));
    //     }
    //   }
    // }
  } else {
    print("================ NOT MERCHANT ================");
  }
}

// Initialize local notification
Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  ); //launcher_icon

  DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings();

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Show local notification function
Future<void> _showLocalNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;

  if (notification != null) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'zaitona_channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title ?? '',
      notification.body ?? '',
      notificationDetails,
    );
  }
}

class FirebaseUnsubscribe {
  static Future unsubscribeFromTopics() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String userId = Caching.getData(key: AppConstance.loggedInUserKey);
    bool isClient = Caching.getData(key: AppConstance.clientCachedKey) != null;
    bool isDriver = Caching.getData(key: AppConstance.driverCachedKey) != null;
    bool isMerchant = Caching.getData(key: AppConstance.merchantCachedKey) != null;

    // await messaging.unsubscribeFromTopic('all');
    await messaging.unsubscribeFromTopic('hala-babel-all');
    await messaging.unsubscribeFromTopic('user-$userId');

    if (isClient) {
      print('----- client');
      await messaging.unsubscribeFromTopic('clients');
    }
    if (isDriver) {
      print('----- driver');
      await messaging.unsubscribeFromTopic('drivers');
    }
    if (isMerchant) {
      print('----- merchant');
      await messaging.unsubscribeFromTopic('merchants');
    }
  }
}

class FirebaseNotifications {
  // // ======================= LOCALE NOTIFICATION ========================= //
  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // static onBack(NotificationResponse notificationResponse) {}
  // static Future init() async {
  //   InitializationSettings nativeSetting = const InitializationSettings(
  //     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  //     iOS: DarwinInitializationSettings(),
  //   );
  //   flutterLocalNotificationsPlugin.initialize(
  //     nativeSetting,
  //     onDidReceiveNotificationResponse: onBack,
  //     onDidReceiveBackgroundNotificationResponse: onBack,
  //   );
  // }

  // ==================== FIREBASE ===================== //

  static getFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
      // subscribe
      String userId = Caching.getData(key: AppConstance.loggedInUserKey);
      bool isClient = Caching.getData(key: AppConstance.clientCachedKey) != null;
      bool isDriver = Caching.getData(key: AppConstance.driverCachedKey) != null;
      bool isMerchant = Caching.getData(key: AppConstance.merchantCachedKey) != null;

      await messaging.subscribeToTopic('user-$userId');
      // await messaging.subscribeToTopic('all');
      await messaging.subscribeToTopic('hala-babel-all');

      if (isClient) {
        await messaging.subscribeToTopic('clients');
      }
      if (isDriver) {
        print('sub driver');
        await messaging.subscribeToTopic('drivers');
      }
      if (isMerchant) {
        await messaging.subscribeToTopic('merchants');
      }
      await _initializeLocalNotifications();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (kDebugMode) {
        print("NOTIFICATION : ${event.notification.toString()}");
      }
      // final player = AudioPlayer();
      // player.play(AssetSource('sounds/notification.mp3'));
      _showLocalNotification(event); // Show local notification for foreground
    });

    // FirebaseMessaging.onMessage.listen((event) {
    //   final player = AudioPlayer();
    //   player.play(AssetSource('sounds/notification.mp3'));
    //   showDefaultFlushBar(
    //     context: navigatorKey.currentContext!,
    //     color: Colors.black54.withValues(alpha:0.5),
    //     title: event.notification?.title ?? '',
    //     messageText: event.notification?.body ?? '',
    //   );
    //   // RemoteNotification? notification = event.notification;
    //   // AndroidNotification? android = event.notification?.android;
    //
    //   // // show locale notification
    //   // if (notification != null && android != null) {
    //   //   flutterLocalNotificationsPlugin.show(
    //   //     notification.hashCode,
    //   //     notification.title,
    //   //     notification.body,
    //   //     NotificationDetails(
    //   //       android: AndroidNotificationDetails(
    //   //         notification.title!,
    //   //         notification.body!,
    //   //         importance: Importance.max,
    //   //         priority: Priority.high,
    //   //         // channelDescription: channel.description,
    //   //         // icon: android.smallIcon,
    //   //       ),
    //   //     ),
    //   //   );
    //   // }
    // });

    /// Handle background and terminated state
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage event) async {
//   print('================================================');
// }
