import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;

  double toBeSpent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo')
                      .where('userID', isEqualTo: _uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child:
                            Text("Some error has occurred ${snapshot.error}"),
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

                      for (int i = 0; i < listLength; i++) {
                        toBeSpent += 1;
                      }

                      return Column(
                        children: [
                          Container(),
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(
                                bottom: 15, left: 10, right: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listLength,
                                itemBuilder: (context, index) {
                                  var item = jsonDecode(shoppingList[index]);

                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(item['name']),
                                        subtitle:
                                            Text(item['price'].toString()),
                                        leading: GestureDetector(
                                          child: findLogo(
                                              item['location'].toString()),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          "Store Location:"),
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
                                          onPressed: () async {},
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      );
                    }

                    // Loading data
                    return Center(child: CircularProgressIndicator());
                  })),
        ],
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
