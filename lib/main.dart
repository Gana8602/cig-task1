// Importing required packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/messaging_service/api.dart';

import 'Screens/home_page/home_page.dart';


// Main function
Future<void> main() async {
  // Ensuring Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  // Running the app
  runApp(const MyApp());
}

// MyApp widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Defining routes for navigation
debugShowCheckedModeBanner: false,
      // App title
      title: 'cig task',

      // App theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Starting point of the app
      home: const HomePage(),
    );
  }
}
