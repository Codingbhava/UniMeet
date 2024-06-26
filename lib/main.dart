import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:unimeet/context/auth.dart';
import 'package:unimeet/local_notifications.dart';
import 'package:unimeet/pages/admin.dart';
import 'package:unimeet/pages/join.dart';
import 'package:unimeet/pages/scheduled.dart';
import 'package:unimeet/pages/profile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  LocalNotifications.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.dark(scheme: FlexScheme.gold),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.gold),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        "/usercheck": (context) => UserCheck(),
        "/join": (context) => JoinMeet(),
        "/scheduled": (context) => Scheduled(),
        "/profile": (context) => Profile(),
        "/admin": (context) => AdminPage(),
      },
      home: UserCheck(),
    );
  }
}
