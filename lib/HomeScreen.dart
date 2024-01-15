import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:object_detection/LoaderState.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ModelObjectDetection _objectModel;
  String? _imagePrediction;
  List? _prediction;
  File? _image;
  ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  bool firststate = true; // Changed to true to open the camera immediately
  bool message = false; // Changed to false to hide the message

  //Google Translator
  GoogleTranslator translator = GoogleTranslator();
  String translationResult = "";

  void translate(String text) async {
    Translation translation = await translator.translate(text, to: "bn");
    translationResult = translation.text;
  }

// Mapping for description
  Map<String, String> objectDescriptions = {
    "person": "A human being.",
    "bicycle": "Two-wheeled human-powered vehicle.",
    "car": "Motorized personal transportation vehicle.",
    "motorcycle": "Motorized two-wheeled vehicle.",
    "airplane": "Powered flying vehicle for air travel.",
    "bus": "Large vehicle for group transportation.",
    "train": "On-track vehicle for transportation.",
    "truck": "Large motorized vehicle for transporting goods.",
    "boat": "Watercraft for navigation on water.",
    "traffic light": "Signal for controlling road traffic.",
    "fire hydrant": "Emergency water supply point for firefighters.",
    "stop sign": "Traffic control sign signaling to stop.",
    "parking meter": "Device for paid parking time measurement.",
    "bench": "Long seat for multiple people.",
    "bird": "Feathered flying creature.",
    "cat": "Domesticated feline animal.",
    "dog": "Domesticated canine animal.",
    "horse": "Four-legged riding and working animal.",
    "sheep": "Domesticated livestock for wool and meat.",
    "cow": "Domesticated livestock for milk and meat.",
    "elephant": "Large, long-nosed mammal.",
    "bear": "Large, omnivorous mammal.",
    "zebra": "Striped, horse-like mammal.",
    "giraffe": "Tallest land animal with a long neck.",
    "backpack": "Bag worn on the back for carrying items.",
    "umbrella": "Portable device for rain and sun protection.",
    "handbag": "Small bag for carrying personal items.",
    "tie": "Neckwear for formal attire.",
    "suitcase": "Luggage for travel and storage.",
    "frisbee": "Flying disc for recreational play.",
    "skis": "Equipment for gliding on snow.",
    "snowboard": "Equipment for snowboarding on slopes.",
    "sports ball": "Ball used in various sports.",
    "kite": "Airborne toy controlled by strings.",
    "baseball bat": "Sports equipment for hitting baseballs.",
    "baseball glove": "Protective handwear for baseball.",
    "skateboard": "Four-wheeled board for riding.",
    "surfboard": "Equipment for riding ocean waves.",
    "tennis racket": "Sports equipment for playing tennis.",
    "bottle": "Container for liquids and beverages.",
    "wine glass": "Glass for serving wine.",
    "cup": "Drinking vessel with a handle.",
    "fork": "Eating utensil with prongs.",
    "knife": "Cutting utensil with a sharp blade.",
    "spoon": "Eating utensil for liquids and solids.",
    "bowl": "Deep, round dish for food.",
    "banana": "Yellow, curved fruit.",
    "apple": "Round or oval fruit with skin.",
    "sandwich": "Food item with ingredients between slices of bread.",
    "orange": "Citrus fruit with orange skin.",
    "broccoli": "Green vegetable with florets.",
    "carrot": "Orange vegetable root.",
    "hot dog": "Cooked sausage in a bun.",
    "pizza": "Round dish with toppings on a dough base.",
    "donut": "Sweet fried pastry with a hole.",
    "cake": "Sweet baked dessert.",
    "chair": "Seating furniture with a backrest.",
    "couch": "Long, cushioned seating for multiple people.",
    "potted plant": "Plant in a container.",
    "bed": "Furniture for sleeping.",
    "dining table": "Furniture for eating meals.",
    "toilet": "Sanitary fixture for human waste disposal.",
    "TV": "Television for broadcasting visual content.",
    "laptop": "Portable computer.",
    "mouse": "Input device for computer navigation.",
    "remote": "Device for controlling electronic equipment.",
    "keyboard": "Input device for typing on a computer.",
    "cell phone": "Portable communication device.",
    "microwave": "Appliance for cooking or heating food.",
    "oven": "Appliance for baking and roasting.",
    "toaster": "Appliance for toasting bread.",
    "sink": "Basin for water use in kitchens and bathrooms.",
    "refrigerator": "Appliance for cooling and preserving food.",
    "book": "Printed or digital reading material.",
    "clock": "Device for telling time.",
    "vase": "Container for displaying flowers.",
    "scissors": "Cutting tool with two blades.",
    "teddy bear": "Stuffed toy bear.",
    "hair drier": "Appliance for drying hair.",
    "toothbrush": "Tool for cleaning teeth."
  };
  String? getDescriptionBySubstring(String? className) {
    if (className != null) {
      for (final key in objectDescriptions.keys) {
        if (className.toLowerCase().contains(key.toLowerCase())) {
          return objectDescriptions[key];
        }
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    runObjectDetection(); // Automatically run the object detection when the app starts
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 80, 640, 640,
          labelPath: "assets/labels/labels.txt");
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    setState(() {
      firststate = true;
    });
  }

  Future runObjectDetection() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);
    objDetect.forEach((element) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    });

    // for (ResultObjectDetection? result in objDetect) {
    //   if (result != null) {
    //     await flutterTts.speak(result.className ?? "");
    //   }
    // }

    scheduleTimeout(5 * 1000);
    setState(() {
      _image = File(image.path);
    });
  }

  final FlutterTts flutterTts = FlutterTts();

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
  }

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    // Move the margin to the outer container
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      // Adjust the radius as needed
                      child: Container(
                        color: Colors.black26,
                        width: 62,
                        height: 4,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                          // Add right, left, top, and bottom padding
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: Colors.white,
                              height: 100, // Set your desired height
                              //margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 36, 0, 0),
                                    // Apply margin to the outer container
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      // Adjust the radius as needed
                                      child: Container(
                                        color: Color(0xff005aee),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 4, 10, 4),
                                        child: const Text(
                                          'Detected Objects',
                                          style: TextStyle(
                                            fontFamily: 'Sora',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 1.26,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Add other content as needed
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Expansion tile 1
                        ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  objDetect.isNotEmpty
                                      ? objDetect[0]?.className ?? 'Unknown'
                                      : 'Unknown',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('images/speaker.png'),
                                onPressed: () {
                                  if (objDetect.isNotEmpty) {
                                    flutterTts.speak(
                                        objDetect[0]?.className ?? 'Unknown');
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black, // Set the desired color
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Icons
                                        .translate), // Use Icons.translate to represent translation
                                  ),
                                  onPressed: () {
                                    String classNameToTranslate =
                                        objDetect[0]?.className ?? 'Unknown';
                                    if (classNameToTranslate != null) {
                                      translate(classNameToTranslate);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Bangla Translation',
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            translationResult,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Add your translated text here
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.26,
                                                  color: Color(0xff005aee),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                          children: [
                            Container(
                              color: Colors.white,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.fromLTRB(24, 6, 24, 4),
                              child: Text(
                                objDetect.isNotEmpty
                                    ? getDescriptionBySubstring(
                                            objDetect[0]?.className) ??
                                        'Description not found'
                                    : 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Expansion tile 2
                        ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  objDetect.length >= 2
                                      ? objDetect[1]?.className ?? 'Unknown'
                                      : 'Unknown',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('images/speaker.png'),
                                onPressed: () {
                                  if (objDetect.length >= 2) {
                                    flutterTts.speak(
                                        objDetect[1]?.className ?? 'Unknown');
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black, // Set the desired color
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Icons
                                        .translate), // Use Icons.translate to represent translation
                                  ),
                                  onPressed: () {
                                    String classNameToTranslate =
                                        objDetect[1]?.className ?? 'Unknown';
                                    if (classNameToTranslate != null) {
                                      translate(classNameToTranslate);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Bangla Translation',
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            translationResult,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Add your translated text here
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.26,
                                                  color: Color(0xff005aee),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                          children: [
                            Container(
                              color: Colors.white,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.fromLTRB(24, 6, 24, 4),
                              child: Text(
                                objDetect.length >= 2
                                    ? getDescriptionBySubstring(
                                            objDetect[1]?.className) ??
                                        'Description not found'
                                    : 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Expansion tile 3
                        ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  objDetect.length >= 3
                                      ? objDetect[2]?.className ?? 'Unknown'
                                      : 'Unknown',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('images/speaker.png'),
                                onPressed: () {
                                  if (objDetect.length >= 3) {
                                    flutterTts.speak(
                                        objDetect[2]?.className ?? 'Unknown');
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black, // Set the desired color
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Icons
                                        .translate), // Use Icons.translate to represent translation
                                  ),
                                  onPressed: () {
                                    String classNameToTranslate =
                                        objDetect[2]?.className ?? 'Unknown';
                                    if (classNameToTranslate != null) {
                                      translate(classNameToTranslate);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Bangla Translation',
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            translationResult,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Add your translated text here
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.26,
                                                  color: Color(0xff005aee),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                          children: [
                            Container(
                              color: Colors.white,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.fromLTRB(24, 6, 24, 4),
                              child: Text(
                                objDetect.length >= 3
                                    ? getDescriptionBySubstring(
                                            objDetect[2]?.className) ??
                                        'Description not found'
                                    : 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //expansion tile 4
                        ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  objDetect.length >= 4
                                      ? objDetect[3]?.className ?? 'Unknown'
                                      : 'Unknown',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('images/speaker.png'),
                                onPressed: () {
                                  if (objDetect.length >= 4) {
                                    flutterTts.speak(
                                        objDetect[3]?.className ?? 'Unknown');
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black, // Set the desired color
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Icons
                                        .translate), // Use Icons.translate to represent translation
                                  ),
                                  onPressed: () {
                                    String classNameToTranslate =
                                        objDetect[3]?.className ?? 'Unknown';
                                    if (classNameToTranslate != null) {
                                      translate(classNameToTranslate);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Bangla Translation',
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            translationResult,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Add your translated text here
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.26,
                                                  color: Color(0xff005aee),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                          children: [
                            Container(
                              color: Colors.white,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.fromLTRB(24, 6, 24, 4),
                              child: Text(
                                objDetect.length >= 4
                                    ? getDescriptionBySubstring(
                                            objDetect[3]?.className) ??
                                        'Description not found'
                                    : 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Expansion tile 5
                        ExpansionTile(
                          title: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  objDetect.length >= 5
                                      ? objDetect[4]?.className ?? 'Unknown'
                                      : 'Unknown',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('images/speaker.png'),
                                onPressed: () {
                                  if (objDetect.length >= 5) {
                                    flutterTts.speak(
                                        objDetect[4]?.className ?? 'Unknown');
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black, // Set the desired color
                                      BlendMode.srcIn,
                                    ),
                                    child: Icon(Icons
                                        .translate), // Use Icons.translate to represent translation
                                  ),
                                  onPressed: () {
                                    String classNameToTranslate =
                                        objDetect[4]?.className ?? 'Unknown';
                                    if (classNameToTranslate != null) {
                                      translate(classNameToTranslate);
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Bangla Translation',
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          content: Text(
                                            translationResult,
                                            style: TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          // Add your translated text here
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.26,
                                                  color: Color(0xff005aee),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                          children: [
                            Container(
                              color: Colors.white,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.fromLTRB(24, 6, 24, 4),
                              child: Text(
                                objDetect.length >= 5
                                    ? getDescriptionBySubstring(
                                            objDetect[4]?.className) ??
                                        'Description not found'
                                    : 'Unknown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff005aee),
        elevation: 0,
        title: const Text(
          'Go Back',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            height: 1.26,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            firststate
                ? Expanded(
                    child: Container(
                      child: _image != null
                          ? _objectModel.renderBoxesOnImage(_image!, objDetect)
                          : CircularProgressIndicator(), // Show loading indicator while capturing the image
                    ),
                  )
                : Text("Select the Camera to Begin Detections"),
            Center(
              child: Visibility(
                visible: _imagePrediction != null,
                child: Text("$_imagePrediction"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity, // Set your desired width
        height: 56, // Set your desired height
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          // Add your desired border radius
          child: FloatingActionButton.extended(
            onPressed: _showBottomSheet,
            backgroundColor: Color(0xff005aee),
            label: Container(
              margin: EdgeInsets.all(8), // Add your desired margin
              child: const Text(
                'Show Result',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w500,
                  height: 1.26,
                  color: Colors.white,
                  letterSpacing: 0, // Add your desired letter spacing
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Add your desired border radius
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
