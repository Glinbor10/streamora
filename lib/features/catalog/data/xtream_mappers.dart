import 'package:streamora/features/catalog/domain/media.dart';
import 'package:xtream_code_client/xtream_code_client.dart' as x;

/// Maps xtream_code_client models to the domain. Pure functions, so they can
/// be tested without a server.
abstract final class XtreamMappers {
  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Categories without id or name are dropped.
  static List<MediaCategory> categories(List<x.Category> input) => [
    for (final c in input)
      if (c.categoryId != null && _clean(c.categoryName) != null)
        MediaCategory(id: c.categoryId!, name: _clean(c.categoryName)!),
  ];

  /// Channels without id are dropped; the name falls back to "Channel id".
  static List<LiveChannel> live(List<x.LiveStreamItem> input) => [
    for (final i in input)
      if (i.streamId != null)
        LiveChannel(
          id: i.streamId!,
          title: _clean(i.name) ?? 'Channel ${i.streamId}',
          logoUrl: _clean(i.streamIcon),
          categoryId: i.categoryId ?? _first(i.categoryIds),
        ),
  ];

  /// Movies without id are dropped.
  static List<Movie> movies(List<x.VodItem> input) => [
    for (final i in input)
      if (i.streamId != null)
        Movie(
          id: i.streamId!,
          title: _clean(i.name) ?? _clean(i.title) ?? 'Movie ${i.streamId}',
          posterUrl: _clean(i.streamIcon),
          categoryId: i.categoryId ?? _first(i.categoryIds),
          year: _clean(i.year),
          rating: i.rating,
          extension: _clean(i.containerExtension) ?? 'mp4',
        ),
  ];

  /// Series without id are dropped.
  static List<Series> series(List<x.SeriesItem> input) => [
    for (final i in input)
      if (i.seriesId != null)
        Series(
          id: i.seriesId!,
          title: _clean(i.name) ?? _clean(i.title) ?? 'Series ${i.seriesId}',
          coverUrl: _clean(i.cover),
          backdropUrl: _first(i.backdropPath),
          categoryId: i.categoryId ?? _first(i.categoryIds),
          plot: _clean(i.plot),
          genre: _clean(i.genre),
          rating: i.rating,
          year: _clean(i.year),
        ),
  ];

  /// Movie detail from `get_vod_info`.
  static MovieDetail movieDetail(x.VodInfo info) {
    final d = info.info;
    return MovieDetail(
      plot: _clean(d.plot) ?? _clean(d.description),
      genre: _clean(d.genre),
      cast: _clean(d.cast) ?? _clean(d.actors),
      director: _clean(d.director),
      duration: _clean(d.duration),
      backdropUrl: _first(d.backdropPath),
    );
  }

  /// Seasons and episodes from `get_series_info`.
  static SeriesDetail seriesDetail(Series series, x.SeriesInfo info) {
    final bySeason = <int, List<Episode>>{};
    for (final entry in (info.episodes ?? const {}).entries) {
      final fallbackSeason = int.tryParse(entry.key) ?? 1;
      for (final e in entry.value) {
        if (e.id == null) continue;
        final season = e.season ?? fallbackSeason;
        (bySeason[season] ??= []).add(
          Episode(
            id: e.id!,
            season: season,
            number: e.episodeNum ?? 0,
            title: _clean(e.title) ?? 'Episode ${e.episodeNum ?? ''}'.trim(),
            imageUrl: _clean(e.info.movieImage) ?? _clean(e.info.coverBig),
            plot: _clean(e.info.plot),
            duration: _clean(e.info.duration),
            extension: _clean(e.containerExtension) ?? 'mp4',
          ),
        );
      }
    }
    for (final list in bySeason.values) {
      list.sort((a, b) => a.number.compareTo(b.number));
    }
    return SeriesDetail(series: series, episodesBySeason: bySeason);
  }

  static T? _first<T>(List<T>? list) =>
      (list == null || list.isEmpty) ? null : list.first;
}
