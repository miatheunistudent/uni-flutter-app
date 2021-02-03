import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/app.dart';
import 'package:uniapp/core/presentation/res/app_config.dart';
import 'package:uniapp/core/presentation/res/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(
      Provider<AppConfig>(
        child: App(),
        create: (context) => AppConfig(
          appTitle: AppConstants.appName,
          buildFlavor: AppFlavor.prod,
        ),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}
