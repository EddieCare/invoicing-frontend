import 'package:flutter/material.dart';
import 'dart:math';

/// A custom painter to draw a dashed border around a widget.
///
/// This painter allows customization of the border's color, thickness,
/// dash pattern, and corner radius.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to configure the drawing style.
    final paint =
        Paint()
          ..color =
              color // Set the color of the dashes.
          ..strokeWidth =
              strokeWidth // Set the thickness of the dashes.
          ..style =
              PaintingStyle.stroke; // The border is drawn as a line (stroke).

    // Create a path that defines the shape of the border.
    // We use an RRect (Rounded Rectangle) to support rounded corners.
    final path =
        Path()..addRRect(
          borderRadius.toRRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        );

    // Create a dashed path from the original path.
    final dashedPath = _createDashedPath(path, dashWidth, dashSpace);

    // Draw the generated dashed path on the canvas.
    canvas.drawPath(dashedPath, paint);
  }

  /// A helper function to convert a continuous path into a dashed path.
  static Path _createDashedPath(
    Path originalPath,
    double dashWidth,
    double dashSpace,
  ) {
    final dashedPath = Path();
    final totalLength = dashWidth + dashSpace;

    // Use path metrics to iterate over the path's contours.
    for (final metric in originalPath.computeMetrics()) {
      double distance = 0.0;
      // While we still have distance to cover on the path contour...
      while (distance < metric.length) {
        // Extract a segment of the path (a dash).
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        // Move the starting point for the next dash.
        distance += totalLength;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    // The painter should repaint if any of its properties change.
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
