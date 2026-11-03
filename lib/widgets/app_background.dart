import 'package:flutter/material.dart';

/// The same background as the website: soft blue glow top-left,
/// warm amber glow bottom-right, and a faint street-map grid.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        child,
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);

    // Glows
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.8, -1.05),
          radius: 1.1,
          colors: [Color.fromRGBO(37, 99, 166, 0.18), Color.fromRGBO(37, 99, 166, 0)],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(1.0, 1.05),
          radius: 1.0,
          colors: [Color.fromRGBO(242, 181, 68, 0.22), Color.fromRGBO(242, 181, 68, 0)],
        ).createShader(rect),
    );

    // Street grid
    final street = Paint()
      ..color = const Color.fromRGBO(37, 99, 166, 0.09)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final diagonal = Paint()
      ..color = const Color.fromRGBO(37, 99, 166, 0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (double x = 55; x < size.width; x += 110) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), street);
    }
    for (double y = 55; y < size.height; y += 110) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), street);
    }
    for (double k = 220; k < size.width + size.height; k += 220) {
      canvas.drawLine(Offset(0, k), Offset(k, 0), diagonal);
    }

    // Junction dots, and an occasional amber "pin"
    final dot = Paint()..color = const Color.fromRGBO(37, 99, 166, 0.12);
    final pin = Paint()..color = const Color.fromRGBO(242, 181, 68, 0.35);

    for (double y = 0; y < size.height + 220; y += 220) {
      for (double x = 0; x < size.width + 220; x += 220) {
        canvas.drawCircle(Offset(x + 55, y + 55), 3, dot);
        canvas.drawCircle(Offset(x + 165, y + 165), 3, dot);
        canvas.drawCircle(Offset(x + 165, y + 55), 4, pin);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
