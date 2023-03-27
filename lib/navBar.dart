import 'package:flutter/material.dart';
import './auth_controller.dart';
import 'package:get/get.dart';
import './aboutPage.dart';
import './settingsPage.dart';
import './ratePage.dart';

class NavBar extends StatelessWidget {
  String username;
  NavBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.grey[700]),
            accountName: Text("Logged as:", style: TextStyle(fontSize: 20)), 
            accountEmail: Text(username, style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text("Scan receipt", style: TextStyle(fontSize: 18)),
              onTap: null,
            ),

            Divider(color: Colors.grey),
            ListTile(

              leading: Icon(Icons.info),
              title: Text("About", style: TextStyle(fontSize: 18)),
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.pop(context);
                Get.to(()=>About(), transition: Transition.rightToLeftWithFade);  
              }
            ),

            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text("Rate Us", style: TextStyle(fontSize: 18)),
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.pop(context);
                Get.to(()=>Rate(), transition: Transition.rightToLeftWithFade);  
              }
            ),
            
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings", style: TextStyle(fontSize: 18)),
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.pop(context);
                Get.to(()=>Settings(), transition: Transition.rightToLeftWithFade);  
              }
            ),

            ListTile(
              leading: Icon(Icons.coronavirus_sharp),
              title: Text("Cursed Mode (Soon)", style: TextStyle(fontSize: 18), ),
              onTap: null
            ),
            
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out", style: TextStyle(fontSize: 18)),
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                AuthController.instance.logout();
              }
            ),
        ],
      ),

      
    );
  }
}