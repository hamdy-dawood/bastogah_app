import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'core/bloc_observer/bloc_observer.dart';
import 'core/caching/shared_prefs.dart';
import 'core/dependancy_injection/dependancy_injection.dart';
import 'core/helpers/context_extention.dart';
import 'core/update_manager/app_update_manager.dart';
import 'firebase_options.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(name: 'pastoga', options: DefaultFirebaseOptions.currentPlatform);

  setupGetIt();
  await Caching.init();

  Bloc.observer = MyBlocObserver();

  await AppUpdateManager.initialize("com.mdsoft.pastoga", navigatorKey);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale("ar")],
      fallbackLocale: Locale("ar"),
      path: "assets/translations",
      child: const ToastificationWrapper(child: MyApp()),
    ),
  );
}
