import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:object_detection/OCRScreen.dart';
import 'package:object_detection/HomeScreen.dart';
import 'package:object_detection/ColorDetectionScreen.dart';
import 'package:object_detection/HomePage.dart';

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
    _requestMicrophonePermissionAndStartSpeech();
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
          if (_text.toLowerCase().contains('detect colour')) {
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

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 0), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _stopListeningAndNavigateToHome() {
    _stopListening();
    _navigatetohome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 34.0),
          child: Text(
            'Voice Command',
            style: TextStyle(
              fontFamily: 'Sora',
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We are listening..',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Image.asset(
                'images/mic.png', // Replace with the actual image path
                height: 100.0,
                width: 100.0,
                // Add any additional styling or properties as needed
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _stopListeningAndNavigateToHome,
                    icon: Icon(
                      Icons.stop,
                      color: Color(0xff005aee), // Change the color of the stop icon
                    ),
                    label: Text(
                      'Stop Listening',
                      style: TextStyle(
                        fontFamily: 'Sora', // Replace with your font family
                        fontSize: 18.0,
                        color: Colors.black, // Change the text color as needed
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Set the button color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff005aee)), // Add border with blue color
                      ),
                      elevation: 0, // Remove the shadow
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              // ElevatedButton.icon(
              //   onPressed: _speechEnabled
              //       ? () {
              //           _requestMicrophonePermissionAndStartSpeech();
              //           Navigator.pop(
              //               context); // Close the popup after starting
              //         }
              //       : null,
              //   icon: Icon(Icons.mic),
              //   label: Text('Start Listening'),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.blue, // Set the button color
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //   ),
              // ),
              SizedBox(height: 25),
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
                    borderRadius: BorderRadius.circular(100.0),
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
