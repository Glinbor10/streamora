import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/player/data/prefs_progress_repository.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/domain/resume_policy.dart';

WatchProgress _entry(int id, int updatedAtMs, {int positionMs = 60000}) =>
    WatchProgress(
      key: 'movie:$id',
      kind: PlaybackKind.movie,
      id: id,
      title: 'Title $id',
      positionMs: positionMs,
      durationMs: 600000,
      updatedAtMs: updatedAtMs,
    );

void main() {
  late String? blob;
  late PrefsProgressRepository repo;

  setUp(() {
    blob = null;
    repo = PrefsProgressRepository(
      reader: () async => blob,
      writer: (v) async => blob = v,
    );
  });

  test('empty storage returns nothing', () async {
    expect(await repo.all(), isEmpty);
    expect(await repo.get('movie:1'), isNull);
  });

  test('saved entries come back most recent first', () async {
    await repo.save(_entry(1, 100));
    await repo.save(_entry(2, 200));
    expect((await repo.all()).map((e) => e.id), [2, 1]);
  });

  test('saving the same key replaces the entry', () async {
    await repo.save(_entry(1, 100));
    await repo.save(_entry(1, 300, positionMs: 120000));
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(all.single.positionMs, 120000);
  });

  test('remove deletes an entry', () async {
    await repo.save(_entry(1, 100));
    await repo.remove('movie:1');
    expect(await repo.all(), isEmpty);
  });

  test('history is capped at the newest entries', () async {
    for (var i = 0; i < ResumePolicy.maxEntries + 5; i++) {
      await repo.save(_entry(i, i));
    }
    final all = await repo.all();
    expect(all, hasLength(ResumePolicy.maxEntries));
    expect(all.first.id, ResumePolicy.maxEntries + 4);
    expect(all.any((e) => e.id == 0), isFalse);
  });

  test('corrupted data is ignored instead of crashing', () async {
    blob = '{not json';
    expect(await repo.all(), isEmpty);
  });

  test('stored data never contains a playback url', () async {
    await repo.save(_entry(1, 100));
    final decoded = jsonDecode(blob!) as List<dynamic>;
    expect(
      (decoded.single as Map<String, dynamic>).keys,
      isNot(contains('url')),
    );
  });
}
