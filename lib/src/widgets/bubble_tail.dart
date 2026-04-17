import 'package:flutter/material.dart';

/// Custom painter for chat bubble tail
class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isSender;
  final double width;
  final double height;
  final Gradient? gradient;

  BubbleTailPainter({
    required this.color,
    required this.isSender,
    required this.width,
    required this.height,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isSender) {
      // Tail on bottom-right for sender
      path.moveTo(size.width - width, size.height);
      path.lineTo(size.width, size.height - height / 2);
      path.lineTo(size.width - width, size.height - height);
    } else {
      // Tail on bottom-left for receiver
      path.moveTo(width, size.height);
      path.lineTo(0, size.height - height / 2);
      path.lineTo(width, size.height - height);
    }

    path.close();

    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else {
      paint.color = color;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubbleTailPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isSender != isSender ||
        oldDelegate.gradient != gradient;
  }
}