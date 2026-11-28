import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:streamora/features/auth/data/xtream_account_checker.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

const _credentials = Credentials(
  server: 'http://fake.test',
  username: 'user',
  password: 'pass',
);

const _authenticatedBody =
    '{"user_info":{"auth":true,"status":"Active"},"server_info":{}}';
const _rejectedBody = '{"user_info":{"auth":false},"server_info":{}}';

Matcher _failure(AuthFailureType type) =>
    throwsA(isA<AuthFailure>().having((f) => f.type, 'type', type));

Future<void> _checkWith(int statusCode, String body) {
  final client = MockClient((request) async => http.Response(body, statusCode));
  return checkXtreamAccount(_credentials, httpClient: client);
}

void main() {
  test('accepts an authenticated active account', () async {
    await expectLater(
      _checkWith(200, _authenticatedBody),
      completes,
    );
  });

  test('rejects auth == false as unauthorized', () async {
    await expectLater(
      _checkWith(200, _rejectedBody),
      _failure(AuthFailureType.unauthorized),
    );
  });

  test('maps 403 to unauthorized', () async {
    await expectLater(
      _checkWith(403, 'Forbidden'),
      _failure(AuthFailureType.unauthorized),
    );
  });

  test('maps 404 to invalid URL (often a duplicated player_api.php path)',
      () async {
    await expectLater(
      _checkWith(404, 'Not found'),
      _failure(AuthFailureType.invalidUrl),
    );
  });

  test('maps 5xx to a provider server error', () async {
    await expectLater(
      _checkWith(500, 'Server error'),
      _failure(AuthFailureType.serverError),
    );
  });
}
