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
  double rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate"),
        backgroundColor: Colors.blue[300],
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Rating: $rating",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          RatingBar.builder(
              updateOnDrag: true,
              initialRating: 3,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: null,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  hintText: "Email",
                  suffixIcon: IconButton(
                    onPressed: () {
                      //_emailController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
