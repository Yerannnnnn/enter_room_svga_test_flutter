import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ui.Image> randerImageByText(
    {required String content,
    required double fontSize,
    Color? color = Colors.white,
    required double width,
    required double height,
    TextAlign textAlign = TextAlign.justify}) async {
  var recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder);
  Paint paint = Paint()..color = Colors.transparent;
  TextPainter textPainter = TextPainter(
    textAlign: textAlign,
    text: TextSpan(
        text: content,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          // fontFamily: 'DingTalk',
        )),
    textDirection: TextDirection.rtl,
    textWidthBasis: TextWidthBasis.longestLine,
    ellipsis: '...',
    maxLines: 1,
  )..layout(maxWidth: width, minWidth: width);

  double top = (height - textPainter.height) / 2;
  canvas.drawRect(Rect.fromLTRB(0, top, 0 + width, textPainter.height), paint);
// 可以传入minWidth，maxWidth来限制它的宽度，如不传，文字会绘制在一行
  textPainter.paint(canvas, Offset(0, top));
  ui.Picture picture = recorder.endRecording();
  return await picture.toImage(width.toInt(), height.toInt());
}

Future<ui.Image> loadImageByAsset(String asset) async {
  final assetData = await rootBundle.load(asset);
  final u8list = Uint8List.fromList(assetData.buffer.asUint8List());
  ui.Codec codec = await ui.instantiateImageCodec(u8list);
  ui.FrameInfo frame = await codec.getNextFrame();
  return frame.image;
}
