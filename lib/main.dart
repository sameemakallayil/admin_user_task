import 'package:admin_user_task/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'User/user_module.dart';
import 'admin/admin_module.dart';
import 'auth_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAyGR3HzlKmr_vgJQT3_rFOQCzy_qwzRBM",
      appId: "1:600962826552:android:772a6082fcee6b1c4e01cd",
      messagingSenderId: "600962826552",
      projectId: "adminuser-a439e",
    ),
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Role Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',

      routes: {
        '/login': (context) => AuthScreen(),
        '/signup': (context) => SignUpScreen(),
        '/admin': (context) => AdminModule(),
        '/user': (context) => UserModule(),
      },
    );
  }
}


