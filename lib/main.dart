import 'package:budgetit_app/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(milliseconds: 100));
  FlutterNativeSplash.remove();

  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}




