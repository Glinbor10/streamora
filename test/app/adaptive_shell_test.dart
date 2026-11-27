import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/app/shell.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/player/data/prefs_progress_repository.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';
import 'package:streamora/main.dart';
import 'package:streamora/shared/widgets/nav.dart';

import '../features/auth/fakes.dart';

Future<void> pumpDemo(WidgetTester tester, Size size) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        progressRepositoryProvider.overrideWithValue(
          PrefsProgressRepository(
            reader: Future.value,
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
      child: const StreamoraApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('demo')));
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(360, 800), Size(1280, 800)]) {
    testWidgets('movies lay out without errors at ${size.width.toInt()} px', (
      tester,
    ) async {
      await pumpDemo(tester, size);
      expect(find.byType(AdaptiveShell), findsOneWidget);
      expect(find.text('Play'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('phone width uses a bottom NavigationBar', (tester) async {
    await pumpDemo(tester, const Size(360, 800));
    expect(find.byType(FloatingPillNavBar), findsOneWidget);
    expect(find.byType(IconRail), findsNothing);
  });

  testWidgets('desktop width uses a NavigationRail', (tester) async {
    await pumpDemo(tester, const Size(700, 900));
    expect(find.byType(IconRail), findsOneWidget);
    expect(find.byType(FloatingPillNavBar), findsNothing);
  });

  testWidgets('series and live sections render', (tester) async {
    await pumpDemo(tester, const Size(1280, 800));
    await tester.tap(find.byKey(const Key('nav-series')));
    await tester.pumpAndSettle();
    expect(find.text('Search series'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-live')));
    await tester.pumpAndSettle();
    expect(find.text('Search channels'), findsOneWidget);
    expect(find.text('LIVE'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
