import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: Text("Go back to login"), backgroundColor: Colors.blue[300]),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
          width: w,
          height: h * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "img/main_logo.png",
              ),
            ),
          ),
        ),
        Container(
          width: w,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(children: [
            Text(
              "Forgot Password?",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Receive an email to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid email"
                        : null,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    hintText: "Email",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _emailController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                resetPassword();
              },
              child: Container(
                width: w * 0.45,
                height: h * 0.06,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue[300]),
                child: Center(
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      Get.snackbar(
        "About User",
        "User Message",
        backgroundColor: Colors.greenAccent,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Password Reset Email sent!",
          style: TextStyle(color: Colors.white),
        ),
      );
    } on FirebaseAuthException catch (e) {
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
}
