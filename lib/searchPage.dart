import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchApiUrl = Uri.parse(
      "https://us-central1-cop4331c-large-project.cloudfunctions.net/search_product");
  final _searchController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;

  Future<Map<String, dynamic>> searchProduct(
      String search, String location, int time) async {
    var searchResponse = await http.post(searchApiUrl,
        headers: {"Content-type": "application/json"},
        body:
            jsonEncode({'search': search, 'location': location, 'time': time}));
    var data = jsonDecode(searchResponse.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none),
                  hintText: "eg: Fish",
                  prefixIcon: Icon(Icons.manage_search),
                  prefixIconColor: Colors.green,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
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
                      var time = info['timeScope'];

                      // Display list of items
                      return FutureBuilder(
                        future: searchProduct(_searchController.text.trim(),
                            '4167 Mensa Lane, Orlando, FL 32816', time),
                        builder: (context, snapshot1) {
                          if (snapshot1.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container(
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
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot1.data!.length,
                                itemBuilder: (context, index) {
                                  var store =
                                      snapshot1.data!.keys.elementAt(index);
                                  var products = snapshot1.data![store];

                                  // Returns all items for each store
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: products.length,
                                      itemBuilder: (context, index1) {
                                        var product = products[index1];
                                        var productName =
                                            product['name'].toString();
                                        var productPrice = product['price']
                                            .toDouble()
                                            .toStringAsFixed(2);

                                        if (productName.toLowerCase().contains(
                                            _searchController.text
                                                .trim()
                                                .toLowerCase())) {
                                          // Return the widget for the searched items
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: Text(productName),
                                                subtitle:
                                                    Text('\$$productPrice'),
                                                leading: GestureDetector(
                                                  child: findLogo(
                                                      store.toString()),
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                AlertDialog(
                                                                  title: Text(
                                                                      "Store Location:"),
                                                                  content: Text(
                                                                      store
                                                                          .toString()),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child: Text(
                                                                          "Ok",
                                                                          style:
                                                                              TextStyle(color: Colors.green[500])),
                                                                    ),
                                                                  ],
                                                                ));
                                                  },
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.add,
                                                      color: Colors.green),
                                                  onPressed: () async {},
                                                ),
                                              ),
                                              Divider(
                                                  color: Colors.black,
                                                  height: 0),
                                            ],
                                          );
                                        }

                                        // If no items match the search
                                        return Container();
                                      });
                                },
                              ),
                            );
                          }
                        },
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
}
