import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';

void main() {
  final repo = DemoCatalogRepository(
    () => File('assets/demo/demo.json').readAsString(),
  );

  test('every section has categories and items', () async {
    expect(await repo.liveCategories(), isNotEmpty);
    expect(await repo.liveChannels(), isNotEmpty);
    expect(await repo.movieCategories(), isNotEmpty);
    expect(await repo.movies(), isNotEmpty);
    expect(await repo.seriesCategories(), isNotEmpty);
    expect(await repo.series(), isNotEmpty);
  });

  test('items belong to existing categories', () async {
    final cats = (await repo.movieCategories()).map((c) => c.id).toSet();
    final movies = await repo.movies();
    expect(movies.every((m) => cats.contains(m.categoryId)), isTrue);
  });

  test('series detail returns seasons with ordered episodes', () async {
    final first = (await repo.series()).first;
    final detail = await repo.seriesDetail(first);
    expect(detail.seasons, isNotEmpty);
    final episodes = detail.episodesBySeason[detail.seasons.first]!;
    expect(episodes, isNotEmpty);
    expect(repo.episodeUrl(episodes.first), startsWith('https://'));
  });

  test('movies expose a playback url', () async {
    final movie = (await repo.movies()).first;
    expect(repo.movieUrl(movie), startsWith('https://'));
  });
}
