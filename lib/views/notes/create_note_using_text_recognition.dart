import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionView extends StatefulWidget {
  const TextRecognitionView({Key? key}) : super(key: key);

  @override
  State<TextRecognitionView> createState() => _TextRecognitionViewState();
}

class _TextRecognitionViewState extends State<TextRecognitionView> {
  XFile? image;
  bool textScanning = false;
  String scannedText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Text Recognition'),
          actions: [
            IconButton(
              onPressed: () {
                FlutterClipboard.copy(scannedText);
                Fluttertoast.showToast(
                    msg: 'Copied',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    fontSize: 16.0);
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo),
            ),
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text(
                  'Pick image from gallery or use camera to extract text!'),
              if (textScanning) const CircularProgressIndicator(),
              if (!textScanning && image == null)
                Container(
                  width: 450,
                  height: 300,
                  color: Colors.grey[300],
                ),
              if (image != null)
                Image.file(
                  File(image!.path),
                  width: 450,
                  height: 300,
                ),
              Text(
                scannedText,
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null,
              ),
            ],
          ),
        ));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        image = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      image = null;
      scannedText = 'An error occurred while scanning.';
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImg = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImg);
    textRecognizer.close();

    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + '\n';
      }
    }
    textScanning = false;
    setState(() {});
  }
}