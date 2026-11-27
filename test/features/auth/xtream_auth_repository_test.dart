import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

import 'fakes.dart';

void main() {
  const credentials = Credentials(
    server: 'http://fake.test',
    username: 'user',
    password: 'pass',
  );

  late FakeCredentialStore store;

  setUp(() => store = FakeCredentialStore());

  test('login stores credentials when the checker accepts them', () async {
    final repo = XtreamAuthRepository(store: store, checker: (_) async {});
    final session = await repo.login(credentials);
    expect(session, isA<XtreamSession>());
    expect(store.stored, credentials);
  });

  test('login stores nothing when the checker fails', () async {
    final repo = XtreamAuthRepository(
      store: store,
      checker: (_) async =>
          throw const AuthFailure(AuthFailureType.unauthorized),
    );
    await expectLater(
      repo.login(credentials),
      throwsA(
        isA<AuthFailure>().having(
          (f) => f.type,
          'type',
          AuthFailureType.unauthorized,
        ),
      ),
    );
    expect(store.stored, isNull);
  });

  test('restore returns a session for stored valid credentials', () async {
    store.stored = credentials;
    final repo = XtreamAuthRepository(store: store, checker: (_) async {});
    expect(await repo.restore(), isA<XtreamSession>());
  });

  test('restore returns null without credentials or when they fail', () async {
    final repo = XtreamAuthRepository(store: store, checker: (_) async {});
    expect(await repo.restore(), isNull);

    store.stored = credentials;
    final failing = XtreamAuthRepository(
      store: store,
      checker: (_) async => throw const AuthFailure(AuthFailureType.network),
    );
    expect(await failing.restore(), isNull);
  });

  test('demo persists nothing and logout clears credentials', () async {
    final repo = XtreamAuthRepository(store: store, checker: (_) async {});
    expect(repo.startDemo(), isA<DemoSession>());
    expect(store.stored, isNull);

    store.stored = credentials;
    await repo.logout();
    expect(store.stored, isNull);
  });

  test('credentials never print the password', () {
    expect(credentials.toString(), isNot(contains('pass')));
  });
}
