import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mynotes/extentions/buildcontext/loc.dart';

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
          title: Text(context.loc.text_recognition_view_placeholder),
          actions: [
            IconButton(
              onPressed: () {
                FlutterClipboard.copy(scannedText);
                Fluttertoast.showToast(
                    msg: context.loc.text_recognition_view_copy,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.lightBlue[200],
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
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && image == null)
                  Container(
                    alignment: Alignment.center,
                    width: 450,
                    height: 300,
                    color: Colors.grey[300],
                    child: Text(
                      context.loc.text_recognition_view_pick,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (image != null)
                  Image.file(
                    File(image!.path),
                    width: 450,
                    height: 300,
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    scannedText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
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
      scannedText = context.loc.text_recognition_view_error_msg;
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
