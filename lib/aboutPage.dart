import 'package:flutter/material.dart';


class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.blue[300],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "\"Home is where the heart is.\nLove. Live. Budget It!\"", 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pink, fontSize: 26, fontStyle: FontStyle.italic),
              ),
          )
        ]),
    );
  }
}