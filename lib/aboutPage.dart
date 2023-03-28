import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final double coverHeight = 280;
  final double profileHeight = 144;

  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.blue[300],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Text(
              "\"Home is where the heart is.\nLove. Live. Budget It!\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.pink, fontSize: 26, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(15),
            child: Text(
              "Meet our team",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Corey
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.green,
                        ),
                        Text(
                          "Corey Katchen",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lil' bit of\neverything",
                        )
                      ],
                    ),
                  ),
      
                  // Isa
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.blue,
                        ),
                        Text(
                          "Isabella Faille",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Website\n",
                        )
                      ],
                    ),
                  ),
      
                  // Luigi
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.purple,
                        ),
                        Text(
                          "Luigi Muccio",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Mobile App\n",
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Owen
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.yellow,
                        ),
                        Text(
                          "Owen Burns",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Database\n",
                        )
                      ],
                    ),
                  ),
      
                  // Rebeca
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.orange,
                        ),
                        Text(
                          "Rebeca Rodriguez",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Project Manager\n",
                        )
                      ],
                    ),
                  ),
      
                  // Sean
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          backgroundColor: Colors.red,
                        ),
                        Text(
                          "Sean Merkel",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "That guy\n",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              """A project for COP4331 with Dr. Leinecker at the University of Central Florida. We chose this idea to challenge our software development skills. Nonetheless, this was supposed to be a fish app, but someone had to insist...""",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
