
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userInfo')
                  .where('userID', isEqualTo: _uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Some error has occurred ${snapshot.error}"),
                  );
                }

                if (snapshot.hasData) {
                  var docs = snapshot.data.docs;
                  final info = docs[0].data()!;
                  var budget = info['budget'];

                  // Total list expense
                  // Need to be able to calculate this value from Firebase
                  var totalAmount = 99;
                  bool overload = totalAmount > budget;

                  var percentage = totalAmount / (budget.toDouble());
                  String percentageString =
                      (percentage * 100).toStringAsFixed(1);

                  return (Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 80, bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Choose new budget:"),
                                      content: TextField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d{0,2}'))
                                        ],
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: "New Amount",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.red[500])),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("SUBMIT",
                                                style: TextStyle(
                                                    color: Colors.green[500])))
                                      ],
                                    ));
                          },
                          child: Container(
                            width: w * 0.5,
                            height: h * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[300]),
                            child: Center(
                              child: Text(
                                "Edit My Budget",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
                        child: (overload)
                            // Current list exceeds budget
                            ? CircularPercentIndicator(
                                radius: 125,
                                animation: true,
                                animationDuration: 1000,
                                lineWidth: 23.0,
                                percent: 1,
                                circularStrokeCap: CircularStrokeCap.butt,
                                backgroundColor:
                                    Color.fromARGB(70, 151, 149, 149),
                                progressColor: Colors.red,
                                startAngle: 180,
                                center: Text(
                                  "Over budget",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              )
                            // Current list still on budget
                            : CircularPercentIndicator(
                                radius: 125,
                                animation: true,
                                animationDuration: 1000,
                                lineWidth: 23.0,
                                percent: percentage,
                                circularStrokeCap: CircularStrokeCap.butt,
                                backgroundColor:
                                    Color.fromARGB(70, 151, 149, 149),
                                progressColor: Colors.blue[300],
                                startAngle: 180,
                                center: Text(
                                  "$percentageString%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30),
                        child: Text(
                          "\$${totalAmount} / ${budget}\$",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    ],
                  ));
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}


