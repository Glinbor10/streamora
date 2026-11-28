import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/auth/data/xtream_account_checker.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:xtream_code_client/xtream_code_client.dart';

Matcher _failure(AuthFailureType type) =>
    throwsA(isA<AuthFailure>().having((f) => f.type, 'type', type));

void main() {
  test('accepts an authenticated active account', () {
    expect(
      () => ensureAccountUsable(const UserInfo(auth: true, status: 'Active')),
      returnsNormally,
    );
  });

  test('rejects a response without auth (not a real Xtream account)', () {
    expect(
      () => ensureAccountUsable(const UserInfo()),
      _failure(AuthFailureType.unauthorized),
    );
  });

  test('rejects auth == false', () {
    expect(
      () => ensureAccountUsable(const UserInfo(auth: false)),
      _failure(AuthFailureType.unauthorized),
    );
  });

  test('rejects a disabled account', () {
    expect(
      () => ensureAccountUsable(const UserInfo(auth: true, status: 'Disabled')),
      _failure(AuthFailureType.expiredAccount),
    );
  });

  test('rejects an expired account', () {
    expect(
      () => ensureAccountUsable(
        UserInfo(auth: true, expDate: DateTime.utc(2020)),
        now: DateTime.utc(2026),
      ),
      _failure(AuthFailureType.expiredAccount),
    );
  });
}
