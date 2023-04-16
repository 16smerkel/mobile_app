import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  XFile? image;
  final ImagePicker picker = ImagePicker();

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
                ? Padding(
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

    setState(() {
      image = img;
    });
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

                      /*

                      // call uploadReceipt function to get the receipt JSON
                      var receiptJson = await uploadReceipt();

                      // call scanReceipt function with each example JSON
                      var examples = [
                        'new receipt.json',
                      ];
                      for (var example in examples) {
                        var exampleJson = json.decode(
                            await rootBundle.loadString('assets/$example'));
                        await scanReceipt(exampleJson);
                      }*/
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
  Future<Map<String, dynamic>> uploadReceipt() async {
    var request = http.MultipartRequest('POST', Uri.parse(ocrApiUrl))
      ..fields['client_id'] = 'TEST'
      ..fields['recognizer'] = 'auto'
      ..fields['ref_no'] = 'ocr_flutter_123'
      ..files.add(await http.MultipartFile.fromPath('file', 'new receipt.JPG'));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var responseJson = json.decode(response.body)['receipts'][0];
    return responseJson;
  }

  // define function to scan receipt from provided JSON
  Future<void> scanReceipt(Map<String, dynamic> json) async {
    var scanResponse = await http.post(scanApiUrl, body: jsonEncode(json));
    print(scanResponse.body);
  }
}
