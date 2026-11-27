import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/catalog/domain/cached_catalog_repository.dart';
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';

class _CountingRepo implements CatalogRepository {
  int movieCalls = 0;
  int liveCalls = 0;
  bool failMovies = false;

  @override
  Future<List<Movie>> movies() async {
    movieCalls++;
    if (failMovies) throw StateError('boom');
    return [Movie(id: 1, title: 'A')];
  }

  @override
  Future<List<LiveChannel>> liveChannels() async {
    liveCalls++;
    return [LiveChannel(id: 1, title: 'Ch')];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('repeated calls hit the source once', () async {
    final inner = _CountingRepo();
    final repo = CachedCatalogRepository(inner);
    await repo.movies();
    await repo.movies();
    expect(inner.movieCalls, 1);
  });

  test(
    'sections are independent: a failing section does not break others',
    () async {
      final inner = _CountingRepo()..failMovies = true;
      final repo = CachedCatalogRepository(inner);
      await expectLater(repo.movies(), throwsStateError);
      expect(await repo.liveChannels(), hasLength(1));
    },
  );

  test('failures are not cached, so retry reloads', () async {
    final inner = _CountingRepo()..failMovies = true;
    final repo = CachedCatalogRepository(inner);
    await expectLater(repo.movies(), throwsStateError);
    inner.failMovies = false;
    expect(await repo.movies(), hasLength(1));
    expect(inner.movieCalls, 2);
  });

  test('clear forces a reload', () async {
    final inner = _CountingRepo();
    final repo = CachedCatalogRepository(inner);
    await repo.liveChannels();
    repo.clear();
    await repo.liveChannels();
    expect(inner.liveCalls, 2);
  });
}
