import 'package:streamora/features/player/domain/playback.dart';

/// Local storage of watching progress.
abstract interface class ProgressRepository {
  /// All entries, most recent first.
  Future<List<WatchProgress>> all();

  /// The entry stored under [key], if any.
  Future<WatchProgress?> get(String key);

  /// Saves [progress], keeping at most the most recent entries.
  Future<void> save(WatchProgress progress);

  /// Deletes the entry stored under [key].
  Future<void> remove(String key);
}
