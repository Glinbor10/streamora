import 'package:streamora/features/auth/domain/credentials.dart';

/// The current authenticated context of the app.
sealed class AuthSession {
  const new();
}

/// Session backed by a real Xtream account.
final class XtreamSession extends AuthSession {
  /// Creates an Xtream session.
  const new(this.credentials);

  /// Credentials of the account.
  final Credentials credentials;
}

/// Offline demo session with bundled content.
final class DemoSession extends AuthSession {
  /// Creates a demo session.
  const new();
}
