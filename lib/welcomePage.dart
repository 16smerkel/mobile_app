
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './navBar.dart';
import './homePage.dart';
import './listPage.dart';
import './searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}


class _WelcomePageState extends State<WelcomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late final _username = user?.email as String;

  int _currentIndex = 0;

  late var tabs = [
    HomePage(), 
    SearchPage(),
    ListPage(),
  ];


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      drawer: NavBar(username: _username),
      appBar: AppBar(
        title: Text("Budget It"),
        backgroundColor: Colors.blue[300],
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey[300],
        type: BottomNavigationBarType.fixed,
        iconSize: 0.031*h,
        selectedFontSize: 18,
        unselectedFontSize: 18,
        items:  const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.amber,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            backgroundColor: Colors.green,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
            backgroundColor: Colors.amber,
          ),
        ],

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );  
  }
}