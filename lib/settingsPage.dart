import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:non_linear_slider/models/interval.dart';
import 'package:email_validator/email_validator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late final _uid = user?.uid as String;
  final _timeScopeController = TextEditingController();
  final _passwordController = TextEditingController();

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
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Type new password"),
                          content: TextFormField(
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~()]).{8,}$');
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              } else if (value.length < 6) {
                                return "Enter a min. 6 characters";
                              } else if (!regex.hasMatch(value)) {
                                return 'Enter valid password';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                hintText: "New Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _passwordController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                )),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.red[500])),
                            ),
                            TextButton(
                                onPressed: () async {
                                  // Updates user's budget
                                  if (_passwordController.toString().isEmpty) {
                                    return;
                                  }

                                  String password =
                                      _passwordController.text.trim();

                                  //Pass in the password to updatePassword.
                                  user?.updatePassword(password).then((_) {
                                    Get.snackbar(
                                      "About User",
                                      "Password Message",
                                      backgroundColor: Colors.greenAccent,
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        "Password successfully updated!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).catchError((error) {
                                    print(error);
                                    Get.snackbar(
                                      "About User",
                                      "Password Message",
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.TOP,
                                      titleText: Text(
                                        "Could not update password",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                  });

                                  _timeScopeController.clear();
                                  Navigator.pop(context);
                                },
                                child: Text("SUBMIT",
                                    style: TextStyle(color: Colors.green[500])))
                          ],
                        ));
              },
            ),
            _buildDivider(),
            ListTile(
              leading: Icon(
                Icons.alarm,
                color: Colors.blue.shade900,
              ),
              title: Text("Update Time Scope"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                double value = await getTimeScope(_uid) / 60;

                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                              "How long are you willing to travel (in minutes)?"),
                          content: TextField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            autofocus: true,
                            controller: _timeScopeController,
                            decoration: InputDecoration(
                                hintText:
                                    "Searching within ${value.toStringAsFixed(0)} minutes",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _timeScopeController.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                )),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.red[500])),
                            ),
                            TextButton(
                                onPressed: () {
                                  // Updates user's budget
                                  if (_timeScopeController.toString().isEmpty) {
                                    return;
                                  }

                                  var newTimeScope = int.parse(
                                          _timeScopeController.text.trim()) *
                                      60;

                                  updateTimeScope(_uid, newTimeScope);

                                  _timeScopeController.clear();
                                  Navigator.pop(context);
                                },
                                child: Text("SUBMIT",
                                    style: TextStyle(color: Colors.green[500])))
                          ],
                        ));
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

  getTimeScope(String uid) async {
    var collectionReference = await FirebaseFirestore.instance
        .collection('userInfo')
        .where('userID', isEqualTo: uid)
        .get();

    if (collectionReference.docs.isNotEmpty) {
      var document = collectionReference.docs.single;
      var timeScope = document['timeScope'];
      return timeScope;
    }
  }

  void updateTimeScope(String uid, int time) async {
    var collectionReference = await FirebaseFirestore.instance
        .collection('userInfo')
        .where('userID', isEqualTo: uid)
        .get();

    if (collectionReference.docs.isNotEmpty) {
      var document = collectionReference.docs.single.reference;
      document.update({'timeScope': time});
    }
  }
}
