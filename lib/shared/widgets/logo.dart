import 'package:material_ui/material_ui.dart';
import 'package:streamora/shared/theme/app_theme.dart';

/// The streamora symbol: a rounded play triangle crossed by two waves.
class StreamoraLogo extends StatelessWidget {
  /// Creates the logo at [size] logical pixels.
  const new({
    this.size = 48,
    this.color = AppColors.accent,
    this.waveColor = AppColors.background,
    super.key,
  });

  /// Width and height.
  final double size;

  /// Color of the triangle.
  final Color color;

  /// Color of the waves (normally the background color).
  final Color waveColor;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: LogoPainter(color, waveColor)),
  );
}

/// Draws the logo in a 100x100 coordinate space scaled to the canvas.
class LogoPainter extends CustomPainter {
  /// Creates the painter.
  const new(this.color, this.waveColor);

  /// Triangle color.
  final Color color;

  /// Wave color.
  final Color waveColor;

  static Path _triangle() => Path()
    ..moveTo(30, 20)
    ..lineTo(30, 80)
    ..lineTo(80, 50)
    ..close();

  static Path _wave(double y) {
    final path = Path()..moveTo(18, y);
    for (var i = 0; i < 4; i++) {
      final x = 18 + i * 17.0;
      path
        ..relativeQuadraticBezierTo(4.25, i.isEven ? -9 : 9, 8.5, 0)
        ..relativeQuadraticBezierTo(4.25, i.isEven ? 9 : -9, 8.5, 0);
      if (x > 90) break;
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final triangle = _triangle();
    final fill = Paint()..color = color;
    final edge = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawPath(triangle, edge)
      ..drawPath(triangle, fill)
      ..save()
      ..clipPath(triangle);
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(_wave(43), wavePaint)
      ..drawPath(_wave(58), wavePaint)
      ..restore();
  }

  @override
  bool shouldRepaint(LogoPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.waveColor != waveColor;
}
