import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

/// Authentication operations used by the presentation layer.
abstract interface class AuthRepository {
  /// Validates [credentials] against the server and stores them.
  ///
  /// Throws `AuthFailure` on error.
  Future<AuthSession> login(Credentials credentials);

  /// Restores a previous session from stored credentials, or null.
  Future<AuthSession?> restore();

  /// Starts the offline demo session. Nothing is persisted.
  AuthSession startDemo();

  /// Ends the session and deletes stored credentials.
  Future<void> logout();
}
