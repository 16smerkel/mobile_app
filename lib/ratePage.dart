import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Rate extends StatefulWidget {
  const Rate({super.key});

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;
  double rating = 5.0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Rate Us"),
        backgroundColor: Colors.blue[300],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  bool hasReviewed = info['hasReviewed'];

                  if (hasReviewed == true) {
                    return Center(
                      child: Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                                "Thank you for rating us.\n Your feedback is very valuable to us!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Rating: $rating",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("You are more than\njust a number to us!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: RatingBar.builder(
                              updateOnDrag: true,
                              initialRating: 5,
                              minRating: 1,
                              itemSize: 56,
                              itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  this.rating = rating;
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  expands: true,
                                  maxLines: null,
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(0.1),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                      hintText:
                                          "Would you like to leave a comment?",
                                      alignLabelWithHint: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          _commentController.clear();
                                        },
                                        icon: const Icon(Icons.clear),
                                      )),
                                ),
                              ),
                              Container(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  "*All reviews are anonymous",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: GestureDetector(
                            onTap: () {
                              String comment = _commentController.text.trim();
                              _commentController.clear();
                              getRating(rating, comment);
                              updateRating(_uid);
                              setState(() {});
                            },
                            child: Container(
                              width: w * 0.45,
                              height: h * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue[300]),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }

  void updateRating(String uid) async {
    var collectionReference = await FirebaseFirestore.instance
        .collection('userInfo')
        .where('userID', isEqualTo: uid)
        .get();

    if (collectionReference.docs.isNotEmpty) {
      var document = collectionReference.docs.single.reference;
      document.update({'hasReviewed': true});
    }
  }

  void getRating(double rating, String comment) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("reviews");

    Map<String, dynamic> dataToSave = {'rating': rating, 'comment': comment};

    collectionReference.add(dataToSave);
  }
}
