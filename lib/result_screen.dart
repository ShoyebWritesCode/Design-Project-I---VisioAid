import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String translatedText;
  final translator = GoogleTranslator();
  bool isSpeaking = false;
  bool isTranslating = false;

  void _toggleTranslation() async {
    if (isTranslating) {
      // Stop translation
      await _stopTranslation();
    } else {
      // Start translation
      await _translateText();
    }

    // Toggle the state
    setState(() {
      isTranslating = !isTranslating;
    });
  }

  void _toggleSpeech() {
    if (isSpeaking) {
      _stopSpeaking();
    } else {
      _speakText(translatedText);
    }
    setState(() {
      isSpeaking = !isSpeaking;
    });
  }

  @override
  void initState() {
    super.initState();
    translatedText = widget.text; // Set the initial value to the original text
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Detected Text',
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 36.0, bottom: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translatedText,
                  style: TextStyle(fontSize: 24, fontFamily: 'Sora'),
                ),
                SizedBox(height: 16.0), // Custom space between text and buttons
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right:
                              8.0), // Add margin to the right of the first button
                      child: FloatingActionButton(
                        onPressed: () {
                          _copyToClipboard(context, translatedText);
                        },
                        child: Icon(Icons.content_copy),
                        backgroundColor: Color(0xff005aee),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                8.0), // Add horizontal margin to the second button
                        child: FloatingActionButton(
                          onPressed: _toggleSpeech,
                          child:
                              Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                          backgroundColor: Color(0xff005aee),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left:
                                8.0), // Add margin to the left of the third button
                        child: FloatingActionButton(
                          onPressed: _toggleTranslation,
                          child: Icon(
                              isTranslating ? Icons.stop : Icons.translate),
                          backgroundColor: Color(0xff005aee),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  Future<void> _speakText(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  Future _stopSpeaking() async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.stop();
  }

  Future<void> _translateText() async {
    String originalText = widget.text;
    Translation translation =
        await translator.translate(originalText, to: 'bn');
    setState(() {
      translatedText = translation.text!;
    });
  }

  Future<void> _stopTranslation() async {
    setState(() {
      translatedText = widget.text;
    });
  }
}
