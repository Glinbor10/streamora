import 'dart:async';
import 'dart:io';

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
Future<void> checkXtreamAccount(Credentials credentials) async {
  final client = XtreamClient(
    url: credentials.server,
    username: credentials.username,
    password: credentials.password,
    httpClient: UserAgentClient(),
  );
  try {
    final info = await client.serverInformationData().timeout(
      const Duration(seconds: 20),
    );
    ensureAccountUsable(info.userInfo);
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
