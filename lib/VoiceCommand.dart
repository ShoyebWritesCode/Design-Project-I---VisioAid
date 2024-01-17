import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:object_detection/OCRScreen.dart';
import 'package:object_detection/HomeScreen.dart';
import 'package:object_detection/ColorDetectionScreen.dart';

void main() {
  runApp(VoiceCommand());
}

class VoiceCommand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Command',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  String _text = '';
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _speechEnabled = true;
      });
    } else {
      print('Speech recognition is not available');
    }
  }

  Future<void> _requestMicrophonePermissionAndStartSpeech() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      _startListening();
    } else {
      var result = await Permission.microphone.request();

      if (result == PermissionStatus.granted) {
        _startListening();
      } else {
        print('Microphone permission denied');
      }
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          setState(() {
            _text += ' ' + result.recognizedWords;
            _textController.text = _text;
          });

          // Check for specific keywords in the recognized text
          if (_text.toLowerCase().contains('image to text')) {
            // Perform the action you want when 'detect' is recognized
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OCRScreen()),
            );

            // Clear the recognized text after performing the action
            setState(() {
              _text = '';
              _textController.text = '';
            });
          }
          if (_text.toLowerCase().contains('detect object')) {
            // Perform the action you want when 'detect' is recognized
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );

            // Clear the recognized text after performing the action
            setState(() {
              _text = '';
              _textController.text = '';
            });
          }
          if (_text.toLowerCase().contains('detect')) {
            // Perform the action you want when 'detect' is recognized
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ColorDetectionScreen()),
            );

            // Clear the recognized text after performing the action
            setState(() {
              _text = '';
              _textController.text = '';
            });
          }
        }
      },
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Command'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _speechEnabled
                      ? () {
                          _requestMicrophonePermissionAndStartSpeech();
                        }
                      : null,
                  icon: Icon(Icons.mic),
                  label: Text('Start Listening'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _stopListening,
                  icon: Icon(Icons.stop),
                  label: Text('Stop Listening'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showVoiceCommandPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Voice Command Popup'),
          content: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _speechEnabled
                    ? () {
                        _requestMicrophonePermissionAndStartSpeech();
                        Navigator.pop(
                            context); // Close the popup after starting
                      }
                    : null,
                icon: Icon(Icons.mic),
                label: Text('Start Listening'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Set the button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _stopListening();
                  Navigator.pop(context); // Close the popup after stopping
                },
                icon: Icon(Icons.stop),
                label: Text('Stop Listening'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Set the button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:object_detection/HomeScreen.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:object_detection/OCRScreen.dart';
// import 'package:object_detection/HomeScreen.dart';
//
// void main() {
//   runApp(VoiceCommand());
// }
//
// class VoiceCommand extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Voice Command',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late stt.SpeechToText _speech;
//   bool _speechEnabled = false;
//   String _text = '';
//   TextEditingController _textController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }
//
//   Future<void> _initSpeech() async {
//     _speech = stt.SpeechToText();
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() {
//         _speechEnabled = true;
//       });
//     } else {
//       print('Speech recognition is not available');
//     }
//   }
//
//   Future<void> _requestMicrophonePermissionAndStartSpeech() async {
//     var status = await Permission.microphone.status;
//
//     if (status.isGranted) {
//       _startListening();
//     } else {
//       var result = await Permission.microphone.request();
//
//       if (result == PermissionStatus.granted) {
//         _startListening();
//       } else {
//         print('Microphone permission denied');
//       }
//     }
//   }
//
//   void _startListening() {
//     _speech.listen(
//       onResult: (result) {
//         if (result.finalResult) {
//           setState(() {
//             _text += ' ' + result.recognizedWords;
//             _textController.text = _text;
//           });
//
//           // Check for specific keywords in the recognized text
//           if (_text.toLowerCase().contains('image to text')) {
//             // Perform the action you want when 'detect' is recognized
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => OCRScreen()),
//             );
//
//             // Clear the recognized text after performing the action
//             setState(() {
//               _text = '';
//               _textController.text = '';
//             });
//           }
//           if (_text.toLowerCase().contains('detect object')) {
//             // Perform the action you want when 'detect' is recognized
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//
//             // Clear the recognized text after performing the action
//             setState(() {
//               _text = '';
//               _textController.text = '';
//             });
//           }
//         }
//       },
//     );
//   }
//
//   void _stopListening() {
//     _speech.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Command'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // TextField(
//             //   controller: _textController,
//             //   maxLines: 5,
//             //   decoration: InputDecoration(
//             //     hintText: 'Converted Text',
//             //     border: OutlineInputBorder(),
//             //   ),
//             // ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.mic,
//                     size: 36.0,
//                   ),
//                   onPressed: _speechEnabled
//                       ? () {
//                           _requestMicrophonePermissionAndStartSpeech();
//                         }
//                       : null,
//                 ),
//                 SizedBox(width: 16),
//                 IconButton(
//                   icon: Icon(
//                     Icons.stop,
//                     size: 36.0,
//                   ),
//                   onPressed: _stopListening,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
