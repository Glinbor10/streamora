import 'package:streamora/features/auth/domain/credential_store.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

/// In-memory [CredentialStore] for tests.
class FakeCredentialStore implements CredentialStore {
  Credentials? stored;

  @override
  Future<Credentials?> read() async => stored;

  @override
  Future<void> write(Credentials credentials) async => stored = credentials;

  @override
  Future<void> clear() async => stored = null;
}
