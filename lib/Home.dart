// ignore_for_file: file_names, depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:change_case/change_case.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  List<dynamic> _output = [];
  String resultText = '';
  final picker = ImagePicker();
  @override
  void initState() {
    loadModel();
    super.initState();
  }

  Future pickImage() async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      var image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;
      final imageTemp = File(image.path);
      setState(() {
        _image = imageTemp;
      });
      await detectImage(_image!.path);
    } else if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future pickGalleryImage() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      var image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final imageTemp = File(image.path);
      setState(() {
        _image = imageTemp;
      });
      await detectImage(_image!.path);
    } else if (status.isDenied) {
      await Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  detectImage(imagePath) async {
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 120,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/label.txt');
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dog Breed Classifier'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Column(
              children: [
                Container(
                  color: const Color(0xff8dadc0),
                  height: 250,
                  child: _image != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(_image!.path),
                                )),
                          ))
                      : Container(),
                ),
                const SizedBox(
                  height: 30,
                ),
                _output.isNotEmpty
                    ? Column(children: [
                        for (var i in _output)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                    i['label'].toString().toCapitalCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                animation: true,
                                lineHeight: 18.0,
                                animationDuration: 2500,
                                percent: i['confidence'],
                                center: Text(
                                    '${(i['confidence'] * 100).toStringAsFixed(1)} %',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                progressColor: const Color(0xff224760),
                                backgroundColor: const Color(0xff8dadc0),
                              ),
                            ]),
                          ),
                      ])
                    : const Text('No Image Uploaded'),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Open Camera')),
                    ElevatedButton.icon(
                        onPressed: pickGalleryImage,
                        icon: const Icon(Icons.add_photo_alternate_rounded),
                        label: const Text('Open Gallery')),
                  ]),
            ),
          ],
        )));
  }
}
