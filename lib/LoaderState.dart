import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class LoaderState extends StatefulWidget {
  const LoaderState({super.key});

  @override
  State<LoaderState> createState() => _LoaderStateState();
}

class _LoaderStateState extends State<LoaderState>
    with TickerProviderStateMixin {
  late final GifController controller1;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
                color: Color(0XFF0000FFFF),
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Gif(
                image: AssetImage("images/loading.png"),
                controller: controller1,
                autostart: Autostart.loop,
                onFetchCompleted: () {
                  controller1.reset();
                  controller1.forward();
                },
              ),
            )));
  }
}
