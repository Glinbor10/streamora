import 'dart:async';

import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';

/// Memoizes every request of an inner repository in memory.
///
/// Failed requests are not cached, so a retry hits the source again.
class CachedCatalogRepository implements CatalogRepository {
  /// Wraps [_inner].
  new(this._inner);

  final CatalogRepository _inner;
  final Map<String, Future<Object?>> _cache = {};

  Future<T> _once<T>(String key, Future<T> Function() load) {
    final cached = _cache[key];
    if (cached != null) return cached as Future<T>;
    final future = load();
    _cache[key] = future;
    // Forget failures so a retry reloads; callers still get the error.
    unawaited(
      future.then<void>((_) {}, onError: (Object _) => _cache.remove(key)),
    );
    return future;
  }

  /// Drops everything so the next request reloads from the source.
  void clear() => _cache.clear();

  @override
  Future<List<MediaCategory>> liveCategories() =>
      _once('liveCategories', _inner.liveCategories);

  @override
  Future<List<LiveChannel>> liveChannels() =>
      _once('liveChannels', _inner.liveChannels);

  @override
  Future<List<MediaCategory>> movieCategories() =>
      _once('movieCategories', _inner.movieCategories);

  @override
  Future<List<Movie>> movies() => _once('movies', _inner.movies);

  @override
  Future<MovieDetail> movieDetail(Movie movie) =>
      _once('movie:${movie.id}', () => _inner.movieDetail(movie));

  @override
  Future<List<MediaCategory>> seriesCategories() =>
      _once('seriesCategories', _inner.seriesCategories);

  @override
  Future<List<Series>> series() => _once('series', _inner.series);

  @override
  Future<SeriesDetail> seriesDetail(Series series) =>
      _once('series:${series.id}', () => _inner.seriesDetail(series));

  @override
  String liveUrl(LiveChannel channel) => _inner.liveUrl(channel);

  @override
  String movieUrl(Movie movie) => _inner.movieUrl(movie);

  @override
  String episodeUrl(Episode episode) => _inner.episodeUrl(episode);
}
