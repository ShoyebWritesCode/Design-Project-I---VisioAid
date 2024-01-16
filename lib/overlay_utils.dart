// overlay_utils.dart
import 'package:flutter/material.dart';

class OverlayUtils {
  static void showOverlay(BuildContext context) {
    OverlayEntry overlayEntry;

    // Create an AnimationController for the sliding transition
    AnimationController controller = AnimationController(
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      vsync: Overlay.of(context),
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0.0, // Adjust as needed
        left: 0.0,
        right: 0.0,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset(0.0, 0.0),
          ).animate(CurvedAnimation(
            parent: controller, // Use the AnimationController
            curve: Curves.easeInOut,
          )),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400, // Adjust as needed
                color: Color(0xff005aee),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'We are listening..',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 36, // Use FontWeight.normal for thin
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Image.asset(
                      'images/mic.png',
                      width: 76.08,
                      height: 64,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        controller.reverse();
                        //overlayEntry.remove();
                      },
                      child: Text('Turn Off'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Start the animation when the overlay is inserted
    controller.forward();

    // Optionally, you can add a delay or use a Timer to automatically remove the overlay after a certain duration
    // Timer(Duration(seconds: 5), () {
    //   controller.reverse();
    //   overlayEntry.remove();
    // });
  }
}
