import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:object_detection/CameraScreen.dart';
import 'package:object_detection/HomeScreen.dart';
import 'package:object_detection/ObjectDetected.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:object_detection/LoaderState.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:object_detection/SettingsPage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 8), // Add left margin
              child: Image.asset(
                'images/logo_small.png', // Replace with your logo asset path
                width: 116, // Adjust the size as needed
                height: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 16, 8), // Add right padding
            child: IconButton(
              icon: Image.asset(
                'images/custom_settings_icon.png',
                //color: Colors.white,
              ),
              onPressed: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));},
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InkWell(//first one
                onTap: () {
                  // Handle the tap, e.g., navigate to another screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CameraScreen()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 36),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffa0a0a0)),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19616161),
                        offset: Offset(0, 2),
                        blurRadius: 2.5,
                      ),
                      BoxShadow(
                        color: Color(0x16616161),
                        offset: Offset(0, 9),
                        blurRadius: 4.5,
                      ),
                      BoxShadow(
                        color: Color(0x0c616161),
                        offset: Offset(0, 21),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Color(0x02616161),
                        offset: Offset(0, 37),
                        blurRadius: 7.5,
                      ),
                      BoxShadow(
                        color: Color(0x00616161),
                        offset: Offset(0, 57),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(24, 0, 0, 7),
                              child: const Text(
                                'Detect Objects',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                  height: 1.26,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                  //maxWidth: 200, // Set your desired maximum width
                                  ),
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xff005aee),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  // Add left margin
                                  child: Text(
                                    'in Real-Time',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      height: 1.26,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(33, 0, 24, 0),
                        // Add right, left, top, and bottom padding
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 76.08,
                            height: 64,
                            child: Image.asset(
                              'images/card_1.png',
                              width: 76.08,
                              height: 64,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(//2nd one
                onTap: () {
                  // Handle the tap, e.g., navigate to another screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 36),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffa0a0a0)),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19616161),
                        offset: Offset(0, 2),
                        blurRadius: 2.5,
                      ),
                      BoxShadow(
                        color: Color(0x16616161),
                        offset: Offset(0, 9),
                        blurRadius: 4.5,
                      ),
                      BoxShadow(
                        color: Color(0x0c616161),
                        offset: Offset(0, 21),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Color(0x02616161),
                        offset: Offset(0, 37),
                        blurRadius: 7.5,
                      ),
                      BoxShadow(
                        color: Color(0x00616161),
                        offset: Offset(0, 57),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(24, 0, 0, 7),
                              child: const Text(
                                'Detect Objects',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                  height: 1.26,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                  //maxWidth: 200, // Set your desired maximum width
                                  ),
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xff005aee),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  // Add left margin
                                  child: Text(
                                    'from Images',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      height: 1.26,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(33, 0, 24, 0),
                        // Add right, left, top, and bottom padding
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 76.08,
                            height: 64,
                            child: Image.asset(
                              'images/card_2.png',
                              width: 76.08,
                              height: 64,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(//3rd one
                onTap: () {
                  // Handle the tap, e.g., navigate to another screen

                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 36),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffa0a0a0)),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19616161),
                        offset: Offset(0, 2),
                        blurRadius: 2.5,
                      ),
                      BoxShadow(
                        color: Color(0x16616161),
                        offset: Offset(0, 9),
                        blurRadius: 4.5,
                      ),
                      BoxShadow(
                        color: Color(0x0c616161),
                        offset: Offset(0, 21),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Color(0x02616161),
                        offset: Offset(0, 37),
                        blurRadius: 7.5,
                      ),
                      BoxShadow(
                        color: Color(0x00616161),
                        offset: Offset(0, 57),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(24, 0, 0, 7),
                              child: const Text(
                                'Detect       Text',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                  height: 1.26,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                //maxWidth: 200, // Set your desired maximum width
                              ),
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xff005aee),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  // Add left margin
                                  child: Text(
                                    'from Images',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      height: 1.26,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(33, 0, 24, 0),
                        // Add right, left, top, and bottom padding
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 76.08,
                            height: 64,
                            child: Image.asset(
                              'images/card_3.png',
                              width: 76.08,
                              height: 64,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(//4th one
                onTap: () {
                  // Handle the tap, e.g., navigate to another screen
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(24, 16, 24, 24),
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 36),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffa0a0a0)),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19616161),
                        offset: Offset(0, 2),
                        blurRadius: 2.5,
                      ),
                      BoxShadow(
                        color: Color(0x16616161),
                        offset: Offset(0, 9),
                        blurRadius: 4.5,
                      ),
                      BoxShadow(
                        color: Color(0x0c616161),
                        offset: Offset(0, 21),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Color(0x02616161),
                        offset: Offset(0, 37),
                        blurRadius: 7.5,
                      ),
                      BoxShadow(
                        color: Color(0x00616161),
                        offset: Offset(0, 57),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(24, 0, 0, 7),
                              child: const Text(
                                'Detect Colors',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w700,
                                  height: 1.26,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                //maxWidth: 200, // Set your desired maximum width
                              ),
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xff005aee),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  // Add left margin
                                  child: Text(
                                    'from Images',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      height: 1.26,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(33, 0, 24, 0),
                        // Add right, left, top, and bottom padding
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 76.08,
                            height: 64,
                            child: Image.asset(
                              'images/card_4.png',
                              width: 76.08,
                              height: 64,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 16, // Spread of the shadow
              offset: Offset(0, -3), // Offset of the shadow
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: GNav(
            haptic: true,
            //backgroundColor: Colors.black,
            color: Color(0xff005aee),
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xff005aee),
            //gap: 2,
            padding: EdgeInsets.all(12),
            iconSize: 32,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.contact_support,
                text: 'QnA',
                textStyle: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.mic,
                text: 'Voice Assist',
                textStyle: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
