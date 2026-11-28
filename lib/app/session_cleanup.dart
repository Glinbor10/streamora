import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';

/// Empties the cached artwork. Override in tests.
final imageCacheClearerProvider = Provider<Future<void> Function()>(
  (ref) =>
      () => DefaultCacheManager().emptyCache(),
);

/// Signs out and removes per-account local data.
///
/// Credentials are removed first and any failure there aborts the cleanup
/// (fails closed). Clearing progress and artwork is best effort afterwards.
/// Takes a container because the calling widget is gone once the session ends.
Future<void> signOut(ProviderContainer container) async {
  await container.read(authControllerProvider.notifier).logout();
  try {
    await container.read(progressRepositoryProvider).clear();
  } on Object {
    // Best effort: credentials are already gone.
  }
  try {
    await container.read(imageCacheClearerProvider)();
  } on Object {
    // Best effort.
  }
  container.invalidate(continueWatchingProvider);
}
