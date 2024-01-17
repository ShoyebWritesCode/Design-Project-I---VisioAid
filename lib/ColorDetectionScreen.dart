import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ColorDetectionScreen extends StatefulWidget {
  const ColorDetectionScreen({super.key});

  @override
  State<ColorDetectionScreen> createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  bool _hasRunModel = false;
  File? _image;
  List? _result;
  final _picker = ImagePicker();

  //function for load model
  void loadModel() async {
    await Tflite.loadModel(
        model: 'assets/models/model_unquant.tflite',
        labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    _hasRunModel = false;
    super.dispose();
  }

//funtion for color detection
  void detectColor(final File image) async {
    var result = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 9,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _result = result;
      _hasRunModel = true;
    });
  }

  void pickCameraImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectColor(_image!);
  }

  void pickGalleryImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectColor(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Detection',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            height: 1.26,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff005aee),
      ),
      body: _body(context),
    );
  }

  Widget _body(final BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _mediumVerticalSpacer(),
            _hasRunModel
                ? Column(
              children: [
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: _image != null
                      ? Image.file(_image!)
                      : Container(), // Check for null
                ),
                _mediumVerticalSpacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(8), // Add border radius
                  //   border: Border.all(color: Color(0xff005aee),),),

                  child: Text(
                    '${_result?[0]['label'] ?? 'Undefined'}', // Check for null and provide a default value
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                    ),
                  ),
                )
              ],
            )
                : Container(), // Removed the 'detected object' text
            Expanded(child: _selectionButtons())
          ],
        ),

  );
  Widget _selectionButtons() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _selectionPhotos('Capture photo', pickCameraImage),
        SizedBox(height: 16.0), // Adjust the height as needed for spacing
        _selectionPhotos('Select photo', pickGalleryImage),
      ],
    ),
  );

  Widget _selectionPhotos(final String label, final VoidCallback onTap) => Container(
    width: 220,
    height: 60, // Adjust the height
    margin: EdgeInsets.symmetric(horizontal: 24.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff005aee),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Sora',
            fontSize: 24,
          ),
        ),
      ),
    ),
  );

  Widget _mediumVerticalSpacer() => const SizedBox(
    height: 30,
  );


}
