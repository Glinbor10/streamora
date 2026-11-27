// Renders the logo to PNG files used to generate the launcher icons.
//
// Skipped unless ICONS_DIR is set (see .github/workflows/screenshots.yml).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/logo.dart';

final String? _outDir = Platform.environment['ICONS_DIR'];

Future<void> _write(String name, {required bool background}) async {
  const size = 1024.0;
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  if (background) {
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(0, 0, size, size),
        const ui.Radius.circular(size * 0.22),
      ),
      ui.Paint()..color = AppColors.background,
    );
  }
  // Keep the symbol inside the adaptive-icon safe zone (about 62 percent).
  const logoSize = size * 0.62;
  const offset = (size - logoSize) / 2;
  canvas
    ..save()
    ..translate(offset, offset);
  const LogoPainter(
    AppColors.accent,
    AppColors.background,
  ).paint(canvas, const ui.Size(logoSize, logoSize));
  canvas.restore();
  final image = await recorder.endRecording().toImage(1024, 1024);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  File('$_outDir/$name.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(data!.buffer.asUint8List());
}

void main() {
  if (_outDir == null) {
    test('icon export skipped (ICONS_DIR not set)', () {}, skip: true);
    return;
  }
  test('exports launcher icons', () async {
    await _write('icon-1024', background: true);
    await _write('icon-foreground-1024', background: false);
  });
}
