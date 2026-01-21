import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // TODO: Enable after Firebase setup
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // TODO: Firebase configuration files needed (google-services.json, GoogleService-Info.plist)
  // await Firebase.initializeApp();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: SLAMApp(),
    ),
  );
}
