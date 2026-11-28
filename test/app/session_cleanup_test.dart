import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/app/session_cleanup.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/domain/credential_store.dart';
import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/player/data/prefs_progress_repository.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';

import '../features/auth/fakes.dart';

class _ThrowingStore implements CredentialStore {
  @override
  Future<Credentials?> read() async => null;

  @override
  Future<void> write(Credentials credentials) async {}

  @override
  Future<void> clear() async => throw StateError('keystore unavailable');
}

WatchProgress _entry() => const WatchProgress(
  key: 'movie:1',
  kind: PlaybackKind.movie,
  id: 1,
  title: 'T',
  positionMs: 60000,
  durationMs: 600000,
  updatedAtMs: 1,
);

void main() {
  late String? blob;
  late PrefsProgressRepository progress;
  late int cacheClears;

  setUp(() async {
    blob = null;
    cacheClears = 0;
    progress = PrefsProgressRepository(
      reader: () async => blob,
      writer: (v) async => blob = v,
    );
    await progress.save(_entry());
  });

  ProviderContainer containerWith(CredentialStore store) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          XtreamAuthRepository(store: store, checker: (_) async {}),
        ),
        progressRepositoryProvider.overrideWithValue(progress),
        imageCacheClearerProvider.overrideWithValue(() async => cacheClears++),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('sign out removes credentials, progress and cached artwork', () async {
    final store = FakeCredentialStore()
      ..stored = const Credentials(
        server: 'http://fake.test',
        username: 'user',
        password: 'pass',
      );
    final container = containerWith(store);
    await container.read(authControllerProvider.future);

    await signOut(container);

    expect(store.stored, isNull);
    expect(await progress.all(), isEmpty);
    expect(cacheClears, 1);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test(
    'a failing credential delete aborts the cleanup (fails closed)',
    () async {
      final container = containerWith(_ThrowingStore());
      await container.read(authControllerProvider.future);

      await expectLater(signOut(container), throwsStateError);

      expect(await progress.all(), isNotEmpty);
      expect(cacheClears, 0);
    },
  );
}
