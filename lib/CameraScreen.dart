import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  late ModelObjectDetection _objectModel;
  String? _imagePrediction;
  List? _prediction;
  List<ResultObjectDetection?> objDetect = [];
  List<String> detectedObjectNames = [];

  // @override
  // void initState() {
  //   super.initState();

  //   // Initialize the camera
  //   void startImageStream() {
  //     if (_controller != null && _controller.value.isInitialized) {
  //       _controller.startImageStream((CameraImage image) {
  //         if (_objectModel != null) {
  //           runObjectDetection(image);
  //         }
  //       });
  //     }
  //   }

  //   availableCameras().then((cameras) {
  //     if (cameras.isNotEmpty) {
  //       _controller = CameraController(cameras[0], ResolutionPreset.medium);
  //       _controller.initialize().then((_) {
  //         if (mounted) {
  //           setState(() {});
  //           startImageStream();
  //         }
  //       }).catchError((error) {
  //         print("Error initializing camera: $error");
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // Initialize the camera
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _controller.initialize().then((_) {
          if (mounted) {
            setState(() {});
            startImageStream();
          }
        }).catchError((error) {
          print("Error initializing camera: $error");
        });
      }
    });

    loadModel();
  }

  void startImageStream() {
    if (_controller != null && _controller.value.isInitialized) {
      _controller.startImageStream((CameraImage image) {
        if (_objectModel != null) {
          runObjectDetection(image);
        }
      });
    }
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 80, 640, 640,
          labelPath: "assets/labels/labels.txt");
    } catch (e) {
      if (e is PlatformException) {
        print("Only supported for Android, Error is $e");
      } else {
        print("Error is $e");
      }
    }

    // Model loading is complete. Start the image stream after loading the model.
    startImageStream();
  }

  // Future runObjectDetection(CameraImage image) async {
  //   objDetect = await _objectModel.getImagePrediction(image.planes[0].bytes,
  //       minimumScore: 0.1, IOUThershold: 0.3);
  //   objDetect.forEach((element) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   });
  // }

  Future runObjectDetection(CameraImage image) async {
    objDetect = await _objectModel.getImagePrediction(image.planes[0].bytes,
        minimumScore: 0.1, IOUThershold: 0.3);

    detectedObjectNames.clear();

    for (ResultObjectDetection? element in objDetect) {
      if (element != null) {
        detectedObjectNames.add(element.className ?? "");
      }
    }

    setState(() {
      // Update the UI with the detected object names
      this.detectedObjectNames = detectedObjectNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

     return
       Scaffold(
         appBar: AppBar(
           title: Text("Camera Screen"),
           backgroundColor: Color(0xff005aee), // Set the background color of the AppBar
         ),
         body: Column(
           children: <Widget>[
             AspectRatio(
               aspectRatio: _controller.value.aspectRatio,
               child: CameraPreview(_controller),
             ),
             Expanded(
               child: ListView(
                 children: detectedObjectNames.map((name) {
                   return ListTile(
                     title: Text(
                       name,
                       style: TextStyle(
                         color: Colors.red, // Set the text color to red
                         fontSize: 18, // Set the font size as needed
                         fontWeight: FontWeight.bold, // Set the font weight as needed
                       ),
                     ),
                   );
                 }).toList(),
               ),
             ),
           ],
         ),
       );

    // Scaffold(
    //   appBar: AppBar(title: Text("Camera Screen")),
    //   body: Column(
    //     children: <Widget>[
    //       AspectRatio(
    //         aspectRatio: _controller.value.aspectRatio,
    //         child: CameraPreview(_controller),
    //       ),
    //       Expanded(
    //         child: ListView(
    //           children: detectedObjectNames.map((name) {
    //             return ListTile(
    //               title: Text(
    //                 name,
    //                 style: TextStyle(
    //                     color: Colors.red), // Set the text color to red
    //               ),
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
