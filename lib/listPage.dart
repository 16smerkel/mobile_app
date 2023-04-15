import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import './homePage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Stream<QuerySnapshot<Object?>>? myStream;
  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;

  double toBeSpent = 0;

  @override
  void initState() {
    super.initState();
    myStream = FirebaseFirestore.instance
        .collection('userInfo')
        .where('userID', isEqualTo: _uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: myStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Some error has occurred ${snapshot.error}"),
                    );
                  }

                  if (snapshot.hasData) {
                    var docs = snapshot.data.docs;
                    final info = docs[0].data()!;
                    var shoppingList = info['list'];
                    var listLength = shoppingList.length;
                    var budget = info['budget'];

                    if (shoppingList.isEmpty) {
                      return Center(
                          child: Text(
                        "No items were added to your shopping list",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ));
                    }

                    //Total amount to be spent
                    toBeSpent = 0;
                    for (int i = 0; i < listLength; i++) {
                      var item = jsonDecode(shoppingList[i]);
                      toBeSpent += item['price'] * item['amount'];
                    }

                    // Remaining budget
                    double remaining = 0;
                    remaining = budget - toBeSpent;

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlue[100]),
                          child: Text(
                            "Budget: \$${budget.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.purple[100]),
                          child: Text(
                            "Spent so far: \$${toBeSpent.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green[100]),
                          child: Text(
                            "Remaining: \$${remaining.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(
                              top: 5, bottom: 10, left: 15, right: 15),
                          child: Text(
                            "Shopping List:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          margin:
                              EdgeInsets.only(bottom: 15, left: 10, right: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listLength,
                              itemBuilder: (context, index) {
                                var item = jsonDecode(shoppingList[index]);

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(item['name']),
                                      subtitle: Text(
                                          "Qty: ${item['amount'].toStringAsFixed(0)} x \$${item['price'].toStringAsFixed(2)}"),
                                      leading: GestureDetector(
                                        child: findLogo(
                                            item['location'].toString()),
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        Text("Store Location:"),
                                                    content: Text(
                                                        item['location']
                                                            .toString()),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text("Ok",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .green[
                                                                    500])),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () async {
                                          var json = shoppingList[index];
                                          removeFromList(_uid, json);
                                        },
                                      ),
                                    ),
                                    Divider(color: Colors.black, height: 0),
                                  ],
                                );
                              }),
                        ),
                      ],
                    );
                  }

                  // Loading data
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  CircleAvatar findLogo(String storeName) {
    if (storeName.toLowerCase().contains("walmart")) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(child: Image.asset("img/walmartLogo.png")));
    }

    if (storeName.toLowerCase().contains("publix")) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(child: Image.asset("img/publixLogo.png")));
    }

    if (storeName.toLowerCase().contains("costco")) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(child: Image.asset("img/costcoLogo.png")));
    }

    if (storeName.toLowerCase().contains("depot")) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(
              child: Image.asset(
            "img/homeDepotLogo.png",
          )));
    }

    if (storeName.toLowerCase().contains("cvs")) {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(child: Image.asset("img/cvsLogo.png")));
    }

    return CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(child: Image.asset("img/unknownLogo.png")));
  }

  void removeFromList(String uid, String json) async {
    var collectionReference = await FirebaseFirestore.instance
        .collection('userInfo')
        .where('userID', isEqualTo: uid)
        .get();

    if (collectionReference.docs.isNotEmpty) {
      var document = collectionReference.docs.single.reference;
      document.update({
        'list': FieldValue.arrayRemove([json])
      });
    }
  }
}
