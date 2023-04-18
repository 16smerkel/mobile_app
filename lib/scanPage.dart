import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // define API endpoints
  final ocrApiUrl = "https://ocr.asprise.com/api/v1/receipt";
  final scanApiUrl = Uri.parse(
      "https://us-central1-cop4331c-large-project.cloudfunctions.net/scan_receipt");
  File? image;
  final ImagePicker picker = ImagePicker();
  late String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Receipt"),
        backgroundColor: Colors.blue[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('Upload Receipt'),
            ),
            SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  )
          ],
        ),
      ),
    );
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    if (img != null) {
      setState(() {
        image = File(img.path);

        if (image != null) {
          uploadReceipt(image!);
        }
      });
    }
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () async {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () async {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // define function to upload receipt to OCR API and get response
  Future<void> uploadReceipt(File image) async {
    var multiport = await http.MultipartFile.fromPath('file', image.path);

    var request = http.MultipartRequest('POST', Uri.parse(ocrApiUrl));
    request.fields['client_id'] = 'TEST'; // Use 'TEST' for testing purpose
    request.fields['recognizer'] =
        'auto'; // can be 'US', 'CA', 'JP', 'SG' or 'auto'
    request.fields['ref_no'] =
        'ocr_flutter_123'; // optional caller provided ref code
    request.files.add(multiport);

    var response = await request.send();
    if (response.statusCode == 200) {
      print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
      Get.snackbar("", "",
          backgroundColor: Colors.greenAccent,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 15),
          titleText: Text(
            "Receipt Scan Successful",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text("Data has been sent to database!",
              style: TextStyle(color: Colors.white)));

      var responseData = await http.Response.fromStream(response);
      var responseJson = json.decode(responseData.body)['receipts'][0];
      print(responseJson);
      scanReceipt(responseJson);
    } else if (response.statusCode == 429) {
      String responseData1 = await response.stream.bytesToString();
      print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      print('Error: ${response.statusCode}');
      print(responseData1);
      Get.snackbar("", "",
          backgroundColor: Colors.yellow[200],
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 15),
          titleText: Text(
            "Receipt Scan Successful",
            style: TextStyle(color: Colors.black),
          ),
          messageText: Text("Daily quota has already been reached.",
              style: TextStyle(color: Colors.black)));
    } else {
      String responseData1 = await response.stream.bytesToString();
      print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      print('Error: ${response.statusCode}');
      print(responseData1);

      Get.snackbar("", "",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 15),
          titleText: Text(
            "Receipt Scan Failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text("There was an error scanning the image",
              style: TextStyle(color: Colors.white)));
    }
  }

  // define function to scan receipt from provided JSON
  Future<void> scanReceipt(Map<String, dynamic> json) async {
    var scanResponse = await http.post(scanApiUrl, body: jsonEncode(json));
    print(scanResponse.body);

    if (scanResponse.statusCode == 200) {
      print("Yay!!!!");
    } else {
      print("Booooooooooooooo");
    }
  }
}
