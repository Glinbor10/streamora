import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/main.dart';

import 'fakes.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  required XtreamAuthRepository repo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        catalogRepositoryProvider.overrideWithValue(
          DemoCatalogRepository(
            () => File('assets/demo/demo.json').readAsString(),
          ),
        ),
      ],
      child: const StreamoraApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows validation errors and does not call the server', (
    tester,
  ) async {
    var calls = 0;
    await pumpApp(
      tester,
      repo: XtreamAuthRepository(
        store: FakeCredentialStore(),
        checker: (_) async => calls++,
      ),
    );

    await tester.tap(find.byKey(const Key('login')));
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(3));
    expect(calls, 0);
  });

  testWidgets('wrong credentials show an error and stay on login', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repo: XtreamAuthRepository(
        store: FakeCredentialStore(),
        checker: (_) async =>
            throw const AuthFailure(AuthFailureType.unauthorized),
      ),
    );

    await tester.enterText(find.byKey(const Key('server')), 'fake.test');
    await tester.enterText(find.byKey(const Key('username')), 'user');
    await tester.enterText(find.byKey(const Key('password')), 'pass');
    await tester.tap(find.byKey(const Key('login')));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password.'), findsOneWidget);
    expect(find.byKey(const Key('login')), findsOneWidget);
  });

  testWidgets('valid credentials open home, logout returns to login', (
    tester,
  ) async {
    final store = FakeCredentialStore();
    await pumpApp(
      tester,
      repo: XtreamAuthRepository(store: store, checker: (_) async {}),
    );

    await tester.enterText(find.byKey(const Key('server')), 'fake.test');
    await tester.enterText(find.byKey(const Key('username')), 'user');
    await tester.enterText(find.byKey(const Key('password')), 'pass');
    await tester.tap(find.byKey(const Key('login')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('logout')), findsOneWidget);
    expect(store.stored?.server, 'http://fake.test');

    await tester.tap(find.byKey(const Key('logout')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login')), findsOneWidget);
    expect(store.stored, isNull);
  });

  testWidgets('demo mode opens home without storing anything', (tester) async {
    final store = FakeCredentialStore();
    await pumpApp(
      tester,
      repo: XtreamAuthRepository(store: store, checker: (_) async {}),
    );

    await tester.tap(find.byKey(const Key('demo')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('logout')), findsOneWidget);
    expect(store.stored, isNull);
  });

  testWidgets('stored credentials auto-login on start', (tester) async {
    final store = FakeCredentialStore()
      ..stored = const Credentials(
        server: 'http://fake.test',
        username: 'user',
        password: 'pass',
      );
    await pumpApp(
      tester,
      repo: XtreamAuthRepository(store: store, checker: (_) async {}),
    );

    expect(find.byKey(const Key('logout')), findsOneWidget);
  });
}
