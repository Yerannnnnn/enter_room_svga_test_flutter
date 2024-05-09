import 'dart:math';
import 'dart:ui' as ui;

import 'package:enter_room_svga_test/utils.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';

void main() => runApp(const MyApp());

final userID = Random().nextInt(1000);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(top: 200, left: 0, right: 0, child: SVGATest()),
          ],
        ),
      ),
    );
  }
}

class SVGATest extends StatefulWidget {
  const SVGATest({super.key});

  @override
  SVGATestState createState() => SVGATestState();
}

class SVGATestState extends State<SVGATest> with SingleTickerProviderStateMixin {
  late SVGAAnimationController animationController;

  @override
  void initState() {
    animationController = SVGAAnimationController(vsync: this);
    loadAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void loadAnimation() async {
    final videoItem = await SVGAParser.shared.decodeFromAssets("assets/test.svga");

    // 01 name ：207x30
    ui.Image? image01 = await randerImageByText(
      content: "user name",
      color: Colors.white,
      width: double.parse("207"),
      height: double.parse("30"),
      fontSize: double.parse("20"),
      textAlign: TextAlign.center,
    );
    videoItem.dynamicItem.setImage(image01, '01');

    // 02 enter room text 207*31
    ui.Image? image02 = await randerImageByText(
      content: "enter room text",
      color: Colors.white,
      width: double.parse("207"),
      height: double.parse("31"),
      fontSize: double.parse("20"),
      textAlign: TextAlign.center,
    );
    videoItem.dynamicItem.setImage(image02, '02');

    // 03 avatar：60x60
    final avatar = await loadImageByAsset('assets/testAvatar.png');
    videoItem.dynamicItem.setImage(avatar, '03');

    animationController.videoItem = videoItem;
    animationController
        .repeat() // Try to use .forward() .reverse()
        .whenComplete(() {
      return animationController.videoItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SVGAImage(animationController);
  }
}
