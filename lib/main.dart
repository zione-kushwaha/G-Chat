import '/screens/auth_screen.dart';
import '/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAeUdS1i0IWWa2dDWYLwzz-R4pH3cdKjiA",
      appId: "1:943558092328:android:769984e79026df132ab71d",
      messagingSenderId: "943558092328",
      projectId: "flutter-1-6b3f0",
      storageBucket: "flutter-1-6b3f0.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const chat_screen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
