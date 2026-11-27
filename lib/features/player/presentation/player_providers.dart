import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamora/features/player/data/prefs_progress_repository.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/domain/progress_repository.dart';
import 'package:streamora/features/player/domain/resume_policy.dart';

/// Where watching progress is stored. Override in tests.
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => PrefsProgressRepository(),
);

/// Entries for the "Continue watching" row, most recent first.
final continueWatchingProvider = FutureProvider<List<WatchProgress>>((
  ref,
) async {
  final all = await ref.watch(progressRepositoryProvider).all();
  return all.where(ResumePolicy.isContinuable).toList();
});
