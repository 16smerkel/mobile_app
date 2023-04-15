import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
                      var budget = info['budget'];

                      if (shoppingList.isEmpty) {
                        return Center(
                            child: Text(
                          "No items were added to your shopping list",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ));
                      }

                      for(int i = 0; i < shoppingList.length; i++){
                        //toBeSpent += 1;
                      }



                    }

                    // Loading data
                    return Center(child: CircularProgressIndicator());
                  })),
        ],
      ),
    );
  }
}
