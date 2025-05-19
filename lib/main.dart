import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/pages/splash_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Initialize Flutter bindings and Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firestore instance (optional if you’re using Firestore elsewhere)
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(), // Start with Splash Page
      debugShowCheckedModeBanner: false,
    );
  }
}