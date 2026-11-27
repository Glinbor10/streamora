import 'package:streamora/features/player/domain/playback.dart';

/// Rules deciding which progress is stored and where playback resumes.
abstract final class ResumePolicy {
  /// Progress below this position is not worth saving.
  static const minTracked = Duration(seconds: 10);

  /// Fraction from which an item counts as finished.
  static const finishedFraction = 0.95;

  /// Maximum number of stored entries.
  static const maxEntries = 200;

  /// True when [position] of [duration] is worth saving.
  static bool shouldTrack(Duration position, Duration duration) =>
      position >= minTracked && duration > Duration.zero;

  /// True when the item was watched to (almost) the end.
  static bool isFinished(Duration position, Duration duration) =>
      duration > Duration.zero &&
      position.inMilliseconds / duration.inMilliseconds >= finishedFraction;

  /// Where to start: the saved position, or the beginning when there is none
  /// or the item was finished.
  static Duration resumeAt(WatchProgress? progress) {
    if (progress == null) return Duration.zero;
    final position = Duration(milliseconds: progress.positionMs);
    final duration = Duration(milliseconds: progress.durationMs);
    if (isFinished(position, duration)) return Duration.zero;
    return position;
  }

  /// Whether [progress] should appear in "Continue watching".
  static bool isContinuable(WatchProgress progress) =>
      shouldTrack(
        Duration(milliseconds: progress.positionMs),
        Duration(milliseconds: progress.durationMs),
      ) &&
      !isFinished(
        Duration(milliseconds: progress.positionMs),
        Duration(milliseconds: progress.durationMs),
      );
}
