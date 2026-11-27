import 'package:streamora/features/auth/domain/credentials.dart';

/// Persists credentials between app launches.
abstract interface class CredentialStore {
  /// Returns the stored credentials, or null when there are none.
  Future<Credentials?> read();

  /// Stores [credentials], replacing any previous ones.
  Future<void> write(Credentials credentials);

  /// Deletes stored credentials.
  Future<void> clear();
}
