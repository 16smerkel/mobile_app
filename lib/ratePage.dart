import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Rate extends StatefulWidget {
  const Rate({super.key});

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  double rating = 5.0;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Us"),
        backgroundColor: Colors.blue[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Rating: $rating",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: null,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        hintText: "Would you like to leave a comment?",
                        suffixIcon: IconButton(
                          onPressed: () {
                            //_emailController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        )),
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
                onTap: () {},
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
        ),
      ),
    );
  }
}
