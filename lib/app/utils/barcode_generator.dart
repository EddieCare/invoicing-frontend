// import 'dart:typed_data';
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Generates a barcode widget for the given [data] string.
Widget generateBarcodeWidget(
  String data, {
  double width = 300,
  double height = 100,
}) {
  // Generate a Code128 barcode
  final Barcode barcode = Barcode.code128();

  // Create an SVG barcode as a string
  final svg = barcode.toSvg(
    data,
    width: width,
    height: height,
    drawText: false,
    color: 0xFFFFFFFF,
  );

  return SvgPicture.string(svg);
}
