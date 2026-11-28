import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:streamora/shared/user_agent_client.dart';
import 'package:xtream_code_client/xtream_code_client.dart';

/// Verifies credentials against an Xtream server.
///
/// Throws `AuthFailure` when the account cannot be used.
typedef AccountChecker = Future<void> Function(Credentials credentials);

/// Default [AccountChecker] using `xtream_code_client`.
///
/// An [httpClient] can be injected for tests. Debug builds print a sanitized
/// diagnostic to the Flutter console; credentials are never logged.
Future<void> checkXtreamAccount(
  Credentials credentials, {
  http.Client? httpClient,
}) async {
  final transport = _StatusCapturingClient(httpClient ?? UserAgentClient());
  final client = XtreamClient(
    url: credentials.server,
    username: credentials.username,
    password: credentials.password,
    httpClient: transport,
  );
  try {
    final result = await client.serverInformation().timeout(
      const Duration(seconds: 20),
    );
    _log('status=${transport.lastStatusCode}');
    ensureAccountUsable(result.data.userInfo);
  } on AuthFailure {
    rethrow;
  } on TimeoutException {
    throw const AuthFailure(AuthFailureType.network);
  } on SocketException {
    throw const AuthFailure(AuthFailureType.network);
  } on http.ClientException {
    throw const AuthFailure(AuthFailureType.network);
  } on RequestException catch (error) {
    _log('$error (status=${transport.lastStatusCode})');
    throw AuthFailure(_typeForStatus(transport.lastStatusCode));
  } on Object catch (error) {
    _log('${error.runtimeType}: $error');
    throw const AuthFailure(AuthFailureType.unknown);
  } finally {
    client.close();
    _logRequest(transport.lastUri, transport.lastStatusCode);
  }
}

/// Throws [AuthFailure] unless [user] describes an active, authenticated
/// account. A response without `auth == true` (for example a captive portal
/// or a non-Xtream endpoint answering 200) is rejected.
void ensureAccountUsable(UserInfo user, {DateTime? now}) {
  if (user.auth != true) {
    throw const AuthFailure(AuthFailureType.unauthorized);
  }
  final status = user.status?.toLowerCase();
  if (status != null && status != 'active') {
    throw const AuthFailure(AuthFailureType.expiredAccount);
  }
  final expires = user.expDate;
  if (expires != null && expires.isBefore(now ?? DateTime.now())) {
    throw const AuthFailure(AuthFailureType.expiredAccount);
  }
}

/// Maps the HTTP status of the failed request to a user-facing failure.
///
/// A 404 usually means the entered server address already contains a path
/// such as `/player_api.php`, which the client would append a second time.
AuthFailureType _typeForStatus(int? status) {
  if (status == 401 || status == 403) return AuthFailureType.unauthorized;
  if (status == 404) return AuthFailureType.invalidUrl;
  if (status != null && status >= 500) return AuthFailureType.serverError;
  return AuthFailureType.unknown;
}

void _log(String message) {
  if (kDebugMode) debugPrint('[Streamore auth] $message');
}

void _logRequest(Uri? uri, int? status) {
  if (!kDebugMode || uri == null) return;
  // Drop the query string: it contains the username and password.
  final safe = Uri(
    scheme: uri.scheme,
    host: uri.host,
    port: uri.port,
    path: uri.path,
  );
  _log('GET $safe -> ${status ?? 'no response'}');
}

/// Records the status code of the underlying request without changing the
/// response seen by `xtream_code_client`.
class _StatusCapturingClient extends http.BaseClient {
  new(this._inner);

  final http.Client _inner;

  Uri? lastUri;
  int? lastStatusCode;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastUri = request.url;
    final response = await _inner.send(request);
    lastStatusCode = response.statusCode;
    return response;
  }

  @override
  void close() => _inner.close();
}
