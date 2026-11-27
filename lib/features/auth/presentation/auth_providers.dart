import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamora/features/auth/data/secure_credential_store.dart';
import 'package:streamora/features/auth/data/xtream_auth_repository.dart';
import 'package:streamora/features/auth/domain/auth_failure.dart';
import 'package:streamora/features/auth/domain/auth_repository.dart';
import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:streamora/features/auth/domain/url_normalizer.dart';

/// The [AuthRepository] used by the app. Override in tests.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const XtreamAuthRepository(store: SecureCredentialStore()),
);

/// Holds the current [AuthSession] (null when logged out).
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

/// Controls login, demo and logout.
class AuthController extends AsyncNotifier<AuthSession?> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthSession?> build() => _repo.restore();

  /// Logs in with raw form values. Returns the failure, or null on success.
  Future<AuthFailure?> login({
    required String server,
    required String username,
    required String password,
  }) async {
    final normalized = UrlNormalizer.normalize(server);
    if (normalized == null) {
      return const AuthFailure(AuthFailureType.invalidUrl);
    }
    try {
      final session = await _repo.login(
        Credentials(
          server: normalized,
          username: username.trim(),
          password: password,
        ),
      );
      state = AsyncData(session);
      return null;
    } on AuthFailure catch (failure) {
      return failure;
    } on Object {
      return const AuthFailure(AuthFailureType.unknown);
    }
  }

  /// Enters the offline demo session.
  void startDemo() => state = AsyncData(_repo.startDemo());

  /// Logs out and returns to the login screen.
  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncData(null);
  }
}
