import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';
import 'package:streamora/features/catalog/presentation/playback_targets.dart';
import 'package:streamora/features/player/domain/playback.dart';

void main() {
  final repo = DemoCatalogRepository(
    () => Future.value(File('assets/demo/demo.json').readAsStringSync()),
  );

  test('movie target uses the repository url and a progress key', () async {
    final movie = (await repo.movies()).first;
    final target = movieTarget(repo, movie);
    expect(target.kind, PlaybackKind.movie);
    expect(target.url, startsWith('https://'));
    expect(target.progressKey, 'movie:${movie.id}');
  });

  test('episode target queues every later episode in order', () async {
    final series = (await repo.series()).first;
    final detail = await repo.seriesDetail(series);
    final ordered = [
      for (final s in detail.seasons) ...detail.episodesBySeason[s]!,
    ];
    final target = episodeTarget(repo, detail, ordered.first);
    expect(target.upNext, hasLength(ordered.length - 1));
    expect(target.upNext.first.id, ordered[1].id);
    expect(target.seriesId, series.id);

    final last = episodeTarget(repo, detail, ordered.last);
    expect(last.upNext, isEmpty);
  });

  test('live target has no progress', () async {
    final channel = (await repo.liveChannels()).first;
    expect(liveTarget(repo, channel).progressKey, isNull);
  });
}
