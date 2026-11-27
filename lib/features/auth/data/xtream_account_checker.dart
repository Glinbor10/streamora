import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:xtream_code_client/xtream_code_client.dart';

/// Many Xtream servers block the default Dart User-Agent, so every request
/// presents a standard player User-Agent instead.
const xtreamUserAgent = 'IPTVSmartersPlayer';

/// Verifies credentials against an Xtream server.
///
/// Throws `AuthFailure` when the account cannot be used.
typedef AccountChecker = Future<void> Function(Credentials credentials);

class _UserAgentClient extends http.BaseClient {
  new(this._inner);

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] = xtreamUserAgent;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// Default [AccountChecker] using `xtream_code_client`.
Future<void> checkXtreamAccount(Credentials credentials) async {
  final client = XtreamClient(
    url: credentials.server,
    username: credentials.username,
    password: credentials.password,
    httpClient: _UserAgentClient(http.Client()),
  );
  try {
    final info = await client.serverInformationData().timeout(
      const Duration(seconds: 20),
    );
    final user = info.userInfo;
    if (user.auth == false) {
      throw const AuthFailure(AuthFailureType.unauthorized);
    }
    final status = user.status?.toLowerCase();
    if (status != null && status != 'active') {
      throw const AuthFailure(AuthFailureType.expiredAccount);
    }
    final expires = user.expDate;
    if (expires != null && expires.isBefore(DateTime.now())) {
      throw const AuthFailure(AuthFailureType.expiredAccount);
    }
  } on AuthFailure {
    rethrow;
  } on TimeoutException {
    throw const AuthFailure(AuthFailureType.network);
  } on SocketException {
    throw const AuthFailure(AuthFailureType.network);
  } on http.ClientException {
    throw const AuthFailure(AuthFailureType.network);
  } on RequestException {
    throw const AuthFailure(AuthFailureType.unauthorized);
  } on Object {
    throw const AuthFailure(AuthFailureType.unknown);
  } finally {
    client.close();
  }
}
