import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final double coverHeight = 280;
  final double profileHeight = 144;

  const About({super.key});

  @override /*js*/
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

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
                  color: Colors.pink,
                  fontSize: 26,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
            child: Text(
              "Meet our team",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Corey
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          child: ClipOval(
                              child: Image.asset(
                            "img/Corey.jpeg",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
                        ),
                        Text(
                          "Corey Katchen",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "API\n",
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
                          child: ClipOval(
                              child: Image.asset(
                            "img/Isa.png",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
                        ),
                        Text(
                          "Isabella Faille",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Front-end\n",
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
                          child: ClipOval(
                              child: Image.asset(
                            "img/Luigi.jpeg",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Owen
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: profileHeight / 3.3,
                          child: ClipOval(
                              child: Image.asset(
                            "img/Owen.png",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
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
                          child: ClipOval(
                              child: Image.asset(
                            "img/Rebeca.jpeg",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
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
                          child: ClipOval(
                              child: Image.asset(
                            "img/Sean.jpg",
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )),
                        ),
                        Text(
                          "Sean Merkel",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Front-end\n",
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
            padding: EdgeInsets.only(top: 25, bottom: 5, left: 15, right: 15),
            child: Text(
              "Purpose",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Text(
              """A project for COP4331 during Spring 2023 with Dr. Leinecker at the University of Central Florida. We chose this idea to challenge our software development skills. Nonetheless, this was supposed to be a fish app.""",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
          ),
          Container(
            width: w,
            height: h * 0.25,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "img/main_logo.png",
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
