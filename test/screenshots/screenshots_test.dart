// Renders the real app screens with the demo catalog to PNG files.
//
// Skipped unless SCREENSHOTS_DIR is set (see .github/workflows/screenshots.yml).
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/player/data/prefs_progress_repository.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';
import 'package:streamora/main.dart';

import '../features/auth/fakes.dart';

final String? _outDir = Platform.environment['SCREENSHOTS_DIR'];
final GlobalKey _boundary = GlobalKey();

Directory _fontsDir() {
  // .../flutter/bin/cache/dart-sdk/bin/dart -> .../flutter
  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 6; i++) {
    final candidate = Directory('${dir.path}/cache/artifacts/material_fonts');
    if (candidate.existsSync()) return candidate;
    dir = dir.parent;
  }
  final root = Platform.environment['FLUTTER_ROOT'];
  return Directory('$root/bin/cache/artifacts/material_fonts');
}

Future<void> _loadFonts(WidgetTester tester) async {
  final files = _fontsDir().listSync().whereType<File>().toList();
  File find(String name) =>
      files.firstWhere((f) => f.uri.pathSegments.last.toLowerCase() == name);

  Future<void> load(String family, List<String> names) async {
    final loader = FontLoader(family);
    for (final n in names) {
      final bytes = find(n).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await tester.runAsync(() async {
    await load('Roboto', [
      'roboto-regular.ttf',
      'roboto-medium.ttf',
      'roboto-bold.ttf',
      'roboto-black.ttf',
    ]);
    await load('MaterialIcons', ['materialicons-regular.otf']);
  });
}

String _seededProgress() => jsonEncode([
  {
    'key': 'movie:2',
    'kind': 'movie',
    'id': 2,
    'title': 'Sintel',
    'subtitle': null,
    'seriesId': null,
    'positionMs': 360000,
    'durationMs': 900000,
    'updatedAtMs': 2,
  },
  {
    'key': 'movie:3',
    'kind': 'movie',
    'id': 3,
    'title': 'Elephants Dream',
    'subtitle': null,
    'seriesId': null,
    'positionMs': 150000,
    'durationMs': 660000,
    'updatedAtMs': 1,
  },
]);

Future<void> _pump(WidgetTester tester, Size size, double dpr) async {
  tester.view
    ..physicalSize = size * dpr
    ..devicePixelRatio = dpr;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        progressRepositoryProvider.overrideWithValue(
          PrefsProgressRepository(
            reader: () => Future.value(_seededProgress()),
            writer: (_) => Future.value(),
          ),
        ),
        authRepositoryProvider.overrideWithValue(
          XtreamAuthRepository(
            store: FakeCredentialStore(),
            checker: (_) async {},
          ),
        ),
        catalogRepositoryProvider.overrideWithValue(
          DemoCatalogRepository(
            () =>
                Future.value(File('assets/demo/demo.json').readAsStringSync()),
          ),
        ),
      ],
      child: RepaintBoundary(key: _boundary, child: const StreamoraApp()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _shot(WidgetTester tester, String name, double dpr) async {
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final boundary =
        _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: dpr);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$_outDir/$name.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(data!.buffer.asUint8List());
  });
}

Future<void> _scrollDown(WidgetTester tester, double dy) async {
  await tester.drag(
    find.byType(CustomScrollView).hitTestable().first,
    Offset(0, -dy),
  );
  await tester.pumpAndSettle();
}

void _suite(String platform, Size size, double dpr) {
  testWidgets('$platform screenshots', (tester) async {
    await _loadFonts(tester);
    await _pump(tester, size, dpr);
    await _shot(tester, '$platform-1-login', dpr);

    await tester.tap(find.byKey(const Key('demo')));
    await tester.pumpAndSettle();
    await _shot(tester, '$platform-2-movies', dpr);

    await tester.tap(find.text('More info'));
    await tester.pumpAndSettle();
    await _shot(tester, '$platform-3-movie-detail', dpr);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await _scrollDown(tester, size.height * 0.8);
    await _shot(tester, '$platform-4-movies-rows', dpr);

    await tester.tap(find.text('Series').last);
    await tester.pumpAndSettle();
    await _shot(tester, '$platform-5-series', dpr);

    await tester.tap(find.text('Live TV').last);
    await tester.pumpAndSettle();
    await _shot(tester, '$platform-6-live', dpr);
  });
}

void main() {
  if (_outDir == null) {
    test('screenshots skipped (SCREENSHOTS_DIR not set)', () {}, skip: true);
    return;
  }
  _suite('windows', const Size(1280, 800), 1);
  _suite('android', const Size(412, 892), 2.625);
}
