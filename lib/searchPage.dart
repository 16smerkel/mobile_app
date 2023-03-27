import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
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
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: (){},
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
                            trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: (){},
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
}