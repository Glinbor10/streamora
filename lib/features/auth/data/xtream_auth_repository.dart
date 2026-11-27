import 'package:streamora/features/auth/data/xtream_account_checker.dart';
import 'package:streamora/features/auth/domain/auth_repository.dart';
import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/domain/credential_store.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

/// [AuthRepository] for Xtream accounts plus the offline demo session.
class XtreamAuthRepository implements AuthRepository {
  /// Creates the repository.
  const new({required this._store, this._checker = checkXtreamAccount});

  final CredentialStore _store;
  final AccountChecker _checker;

  @override
  Future<AuthSession> login(Credentials credentials) async {
    await _checker(credentials);
    await _store.write(credentials);
    return XtreamSession(credentials);
  }

  @override
  Future<AuthSession?> restore() async {
    final credentials = await _store.read();
    if (credentials == null) return null;
    try {
      await _checker(credentials);
    } on Object {
      return null;
    }
    return XtreamSession(credentials);
  }

  @override
  AuthSession startDemo() => const DemoSession();

  @override
  Future<void> logout() => _store.clear();
}
