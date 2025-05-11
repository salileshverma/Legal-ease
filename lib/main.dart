import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled2/Lawyer.dart';
import 'splashscreen.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'ProfilePage.dart';
import 'Notification.dart';
import 'Lawyer.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/contact': (context) => ProfilePage(),
        '/Notification':(context)=>NotificationPage(),
        '/Lawyer':(context)=>LawyerPage(),
      },
    );
  }
}


