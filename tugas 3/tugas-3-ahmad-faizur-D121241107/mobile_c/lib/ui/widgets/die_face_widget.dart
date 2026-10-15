import 'package:flutter/material.dart';

class DieFaceWidget extends StatelessWidget {
  final int value; // 1 to 6
  final double size;
  final Color dotColor;

  const DieFaceWidget({
    super.key,
    required this.value,
    this.size = 32.0,
    this.dotColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DieFacePainter(value: value, dotColor: dotColor),
    );
  }
}

class DieFacePainter extends CustomPainter {
  final int value;
  final Color dotColor;

  DieFacePainter({required this.value, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.11;
    final left = size.width * 0.24;
    final center = size.width * 0.5;
    final right = size.width * 0.76;

    final top = size.height * 0.24;
    final middle = size.height * 0.5;
    final bottom = size.height * 0.76;

    void drawDot(double x, double y) {
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    switch (value) {
      case 1:
        drawDot(center, middle);
        break;
      case 2:
        drawDot(right, top);
        drawDot(left, bottom);
        break;
      case 3:
        drawDot(right, top);
        drawDot(center, middle);
        drawDot(left, bottom);
        break;
      case 4:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 5:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(center, middle);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      case 6:
        drawDot(left, top);
        drawDot(right, top);
        drawDot(left, middle);
        drawDot(right, middle);
        drawDot(left, bottom);
        drawDot(right, bottom);
        break;
      default:
        drawDot(center, middle);
    }
  }

  @override
  bool shouldRepaint(covariant DieFacePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.dotColor != dotColor;
  }
}
