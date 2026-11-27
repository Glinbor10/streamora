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

  /// One smooth sine period from x=36 to x=60, centered on [y].
  static Path _wave(double y) => Path()
    ..moveTo(36, y)
    ..cubicTo(42, y - 8, 48, y - 8, 48, y)
    ..cubicTo(48, y + 8, 54, y + 8, 60, y);

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
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(_wave(44), wavePaint)
      ..drawPath(_wave(57), wavePaint)
      ..restore();
  }

  @override
  bool shouldRepaint(LogoPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.waveColor != waveColor;
}
