import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
          style: TextStyle(
            fontFamily: 'Sora', // Set the Sora font family
          ),
        ),
        backgroundColor: Color(0xff005aee), // Replace with your custom color
      ),
      body: buildFAQPage(),
    );
  }

  Widget buildFAQPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FAQItem(
              question: 'What is the purpose of the app?',
              answer:
                  'The app is designed to identify objects and colors in real-time using the camera of your Android device.',
            ),
            FAQItem(
              question: 'How does the app work?',
              answer:
                  'From homepage, user can scroll through different portions such as detect objects from in real-time, detect objects from objects, detect texts from images, detect colors from images. User can also use voice assistant to run the features. ',
            ),
            FAQItem(
              question: 'What types of objects can the app detect?',
              answer:
                  'The app can detect a wide range of objects, including everyday items, products, fruits, vehicles, groceries etc.',
            ),
            FAQItem(
              question: 'What types of color can the app identify?',
              answer:
                  'The app can identify a wide spectrum of colors from images',
            ),
            FAQItem(
              question: 'What permissions does the app require?',
              answer:
                  'The app requires camera and voice permissions to access the device camera for real-time object and color detection. It also requires internet connection.',
            ),
            FAQItem(
              question: 'What permissions does the app require?',
              answer:
                  'The app requires camera and voice permissions to access the device camera for real-time object and color detection. It also requires internet connection.',
            ),
            FAQItem(
              question: 'Can the app translate objects and texts? ',
              answer:
                  'Yes, the app has the capability to recognize and translate objects and texts present in images.',
            ),

            // Add more FAQItem widgets as needed
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  late final String combinedText = '$question $answer';

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              answer,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Sora', // Set the Sora font family
              ),
            ),
            SizedBox(height: 8.0),
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                _speakText(combinedText);
                // You can implement the logic to play the corresponding sound for the FAQ item
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _speakText(String text) async {
  FlutterTts flutterTts = FlutterTts();
  await flutterTts.setLanguage("en-US");
  await flutterTts.speak(text);
}
