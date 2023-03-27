import 'package:budgetit_app/loginPage.dart';
import 'package:budgetit_app/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthController extends GetxController{
  // AuthController.instace..
  static AuthController instance  = Get.find();
  // Email, password, name...
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady(){
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // Notify user
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);

  }


  _initialScreen(User? user) async{
    if(user == null){
      Get.offAll(()=>LoginPage(), transition: Transition.cupertinoDialog);
    }
    else{
      // Registration error occurs here for user.displayName (it has not saved it yet)
      Get.offAll(()=>WelcomePage(), transition: Transition.cupertinoDialog);
    }
  }

  void register(String username, email, password) async{
    try{
      //await userCredential.user?.updateDisplayName(username); // In case we want to add username
      Get.snackbar("About User", "User Message",
      backgroundColor: Colors.greenAccent,
      snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Account created successfully!",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      );
    }
    catch(e){
      Get.snackbar("About User", "User Message",
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Account creation failed",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white
          )
        )
      );
    }
  }
  

  void login(String email, password) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      Get.snackbar("About Login", "Login Message",
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Login failed",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white
          )
        )
      );
    }
  }


  void logout() async{
    await auth.signOut();
  }

}