import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:budgetit_app/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // User needs to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print(isEmailVerified);

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? WelcomePage()
      : Scaffold(
          appBar: AppBar(
              title: Text("Verify email"), backgroundColor: Colors.blue[300]),
          body: Center(
            child: Text("A verification email has been sent your email.",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
          ),
        );

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Get.snackbar("About User", "User Message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 7),
          titleText: Text(
            "Reset password failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText:
              Text(e.toString(), style: TextStyle(color: Colors.white)));
    }
  }

  Future checkEmailVerified() async {
    // Call after email verificaition
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmailVerified) {
        timer?.cancel();
      }
    }
  }
}
