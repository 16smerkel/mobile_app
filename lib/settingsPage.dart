import 'package:flutter/material.dart';
import 'package:non_linear_slider/models/interval.dart';
import 'package:non_linear_slider/non_linear_slider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blue[300],
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 30)),
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.lock_outline,
                color: Colors.blue.shade900,
              ),
              title: Text("Change Password"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            _buildDivider(),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: Colors.blue.shade900,
              ),
              title: Text("Update Time Scope"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: Text("How long you are willing to travel?"),
                            content: NonLinearSlider(
                              intervals: [
                            NLSInterval(10, 60, 0.25),
                            NLSInterval(60, 800, 0.75),
                              ],
                              value: 50,
                              onChanged: (value) {},
                              divisions: 20,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel",
                                    style: TextStyle(color: Colors.red[500])),
                              )
                            ]));
              },
            ),
          ]),
        )
      ]),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
