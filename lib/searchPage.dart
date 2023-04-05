import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  // Temporary url to see if it works
  final searchApiUrl = Uri.parse("https://us-central1-cop4331c-large-project.cloudfunctions.net/search_product");
  String search = "";

  // ignore: prefer_final_fields
  CollectionReference _referenceList = FirebaseFirestore.instance.collection("test");
  late Stream<QuerySnapshot> _streamList;

  @override
  void initState() {
    super.initState();
    _streamList = _referenceList.orderBy("price").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none
                ),
                hintText: "eg: Fish",
                prefixIcon: Icon(Icons.manage_search),
                prefixIconColor: Colors.green,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: (){
                    
                  },
                )
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                    
                  });
                },
            ),
          ),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(
            stream: _streamList,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return (snapshot.connectionState == ConnectionState.waiting)
               
              ? Center(child: CircularProgressIndicator())
              : Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 15, left: 10, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
              
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              
                    if(search.isEmpty){
                      // Return the widget for all list items
                      return Column(
                        children: [
                          ListTile(
                            title: Text('${data['name']}'),
                            subtitle: Text('\$${data['price'].toDouble().toStringAsFixed(2)}'),
                            // Temporary avatar until cna get data from stores, then display their logo
                            leading: CircleAvatar(backgroundColor: Colors.amber),
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () async {
                                // Test to see if it returns correctly
                                var searchResult = await searchProduct('publix', '4167 Mensa Lane, Orlando, FL 32816', 10000);
                                print(searchResult);
                              },
                              ),
                          ),
                          Divider(color: Colors.black, height: 0),
                        ],
                      );
                    }
              
                    if(data['name'].toString().toLowerCase().contains(search.toLowerCase())){
                      // Return the widget for the searched items
                      return Column(
                        children: [
                          ListTile(
                            title: Text('${data['name']}'),
                            subtitle: Text('\$${data['price'].toDouble().toStringAsFixed(2)}'),
                            // Temporary avatar until cna get data from stores, then display their logo
                            leading: CircleAvatar(backgroundColor: Colors.amber),
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () async {
                                // Test to see if it returns correctly
                                var searchResult = await searchProduct('publix', '4167 Mensa Lane, Orlando, FL 32816', 10000);
                                print(searchResult);
                              },
                              ),
                          ),
                          Divider(color: Colors.black, height: 0),
                        ],
                      );
                    }
              
                    return Container();
                  }),
              );
            },),
          )
        ],
      ),
    );
  }

  // Currently not functional, ask Corey to check
  // Function to search for a product
  Future<List> searchProduct(String search, String location, int time) async {
    var searchResponse = await http.post(searchApiUrl, headers: {"Content-type": "application/json"}, body: jsonEncode({'search': search, 'location': location, 'time': time}));
    return json.decode(searchResponse.body) as List;
  }
}