import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamora/features/auth/domain/credential_store.dart';
import 'package:streamora/features/auth/domain/credentials.dart';

/// [CredentialStore] backed by the platform secure storage.
class SecureCredentialStore implements CredentialStore {
  /// Creates the store.
  const new([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _server = 'auth.server';
  static const _username = 'auth.username';
  static const _password = 'auth.password';

  @override
  Future<Credentials?> read() async {
    final server = await _storage.read(key: _server);
    final username = await _storage.read(key: _username);
    final password = await _storage.read(key: _password);
    if (server == null || username == null || password == null) return null;
    return Credentials(server: server, username: username, password: password);
  }

  @override
  Future<void> write(Credentials credentials) async {
    await _storage.write(key: _server, value: credentials.server);
    await _storage.write(key: _username, value: credentials.username);
    await _storage.write(key: _password, value: credentials.password);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _server);
    await _storage.delete(key: _username);
    await _storage.delete(key: _password);
  }
}
