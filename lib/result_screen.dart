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

  @override
  void initState() {
    super.initState();
    translatedText = widget.text; // Set the initial value to the original text
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Text(translatedText),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _copyToClipboard(context, translatedText);
                    },
                    child: Icon(Icons.content_copy),
                  ),
                  SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () {
                      _speakText(translatedText);
                    },
                    child: Icon(Icons.volume_up),
                  ),
                  SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () async {
                      await _translateText();
                    },
                    child: Icon(Icons.translate),
                  ),
                ],
              ),
            ),
          ],
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

  Future<void> _translateText() async {
    String originalText = widget.text;
    Translation translation =
        await translator.translate(originalText, to: 'bn');
    setState(() {
      translatedText = translation.text!;
    });
  }
}
