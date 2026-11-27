import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/domain/resume_policy.dart';

WatchProgress _progress(int positionMs, int durationMs) => WatchProgress(
  key: 'movie:1',
  kind: PlaybackKind.movie,
  id: 1,
  title: 'T',
  positionMs: positionMs,
  durationMs: durationMs,
  updatedAtMs: 0,
);

void main() {
  test('progress under 10 seconds is not tracked', () {
    expect(
      ResumePolicy.shouldTrack(
        const Duration(seconds: 9),
        const Duration(minutes: 90),
      ),
      isFalse,
    );
    expect(
      ResumePolicy.shouldTrack(
        const Duration(seconds: 10),
        const Duration(minutes: 90),
      ),
      isTrue,
    );
  });

  test('unknown duration is never tracked', () {
    expect(
      ResumePolicy.shouldTrack(const Duration(minutes: 5), Duration.zero),
      isFalse,
    );
  });

  test('95 percent or more counts as finished', () {
    const total = Duration(minutes: 100);
    expect(
      ResumePolicy.isFinished(const Duration(minutes: 94), total),
      isFalse,
    );
    expect(ResumePolicy.isFinished(const Duration(minutes: 95), total), isTrue);
  });

  test('resumes at the saved position, or at zero when finished or empty', () {
    expect(
      ResumePolicy.resumeAt(_progress(12 * 60000, 90 * 60000)),
      const Duration(minutes: 12),
    );
    expect(
      ResumePolicy.resumeAt(_progress(89 * 60000, 90 * 60000)),
      Duration.zero,
    );
    expect(ResumePolicy.resumeAt(null), Duration.zero);
  });

  test('continuable excludes tiny and finished progress', () {
    expect(ResumePolicy.isContinuable(_progress(5000, 90 * 60000)), isFalse);
    expect(
      ResumePolicy.isContinuable(_progress(89 * 60000, 90 * 60000)),
      isFalse,
    );
    expect(
      ResumePolicy.isContinuable(_progress(30 * 60000, 90 * 60000)),
      isTrue,
    );
  });

  test('live targets have no progress key', () {
    const live = PlaybackTarget(
      kind: PlaybackKind.live,
      id: 1,
      title: 'Ch',
      url: 'http://x',
    );
    expect(live.progressKey, isNull);
  });
}
