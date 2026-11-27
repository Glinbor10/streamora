import 'package:meta/meta.dart';
import 'package:streamora/shared/text_normalizer.dart';

/// Anything that can be filtered by category and searched by name.
abstract interface class CatalogEntry {
  /// Display name.
  String get title;

  /// Category the entry belongs to, if any.
  int? get categoryId;

  /// Normalized name used for searching (precomputed once).
  String get searchKey;
}

/// A category of a catalog section.
@immutable
class MediaCategory {
  /// Creates a category.
  const new({required this.id, required this.name});

  /// Category identifier.
  final int id;

  /// Display name.
  final String name;
}

/// A live TV channel.
@immutable
class LiveChannel implements CatalogEntry {
  /// Creates a channel.
  new({
    required this.id,
    required this.title,
    this.logoUrl,
    this.categoryId,
    this.directUrl,
  }) : searchKey = TextNormalizer.normalize(title);

  /// Stream identifier.
  final int id;

  @override
  final String title;

  /// Channel logo.
  final String? logoUrl;

  @override
  final int? categoryId;

  /// Playback URL when the source provides it directly (demo).
  final String? directUrl;

  @override
  final String searchKey;
}

/// A movie (VOD).
@immutable
class Movie implements CatalogEntry {
  /// Creates a movie.
  new({
    required this.id,
    required this.title,
    this.posterUrl,
    this.categoryId,
    this.year,
    this.rating,
    this.extension = 'mp4',
    this.directUrl,
    this.plot,
    this.genre,
  }) : searchKey = TextNormalizer.normalize(title);

  /// Stream identifier.
  final int id;

  @override
  final String title;

  /// Poster (2:3) URL.
  final String? posterUrl;

  @override
  final int? categoryId;

  /// Release year.
  final String? year;

  /// Rating from 0 to 10.
  final double? rating;

  /// Container extension used to build the URL.
  final String extension;

  /// Playback URL when the source provides it directly (demo).
  final String? directUrl;

  /// Synopsis when already known (demo); otherwise see [MovieDetail].
  final String? plot;

  /// Genre label when already known.
  final String? genre;

  @override
  final String searchKey;
}

/// Extra movie information loaded on demand.
@immutable
class MovieDetail {
  /// Creates the detail.
  const new({
    this.plot,
    this.genre,
    this.cast,
    this.director,
    this.duration,
    this.backdropUrl,
  });

  /// Synopsis.
  final String? plot;

  /// Genre label.
  final String? genre;

  /// Main cast.
  final String? cast;

  /// Director.
  final String? director;

  /// Human readable duration.
  final String? duration;

  /// Wide background image.
  final String? backdropUrl;
}

/// A series.
@immutable
class Series implements CatalogEntry {
  /// Creates a series.
  new({
    required this.id,
    required this.title,
    this.coverUrl,
    this.backdropUrl,
    this.categoryId,
    this.plot,
    this.genre,
    this.rating,
    this.year,
  }) : searchKey = TextNormalizer.normalize(title);

  /// Series identifier.
  final int id;

  @override
  final String title;

  /// Cover (2:3) URL.
  final String? coverUrl;

  /// Wide background image.
  final String? backdropUrl;

  @override
  final int? categoryId;

  /// Synopsis.
  final String? plot;

  /// Genre label.
  final String? genre;

  /// Rating from 0 to 10.
  final double? rating;

  /// Release year.
  final String? year;

  @override
  final String searchKey;
}

/// One episode of a series.
@immutable
class Episode {
  /// Creates an episode.
  const new({
    required this.id,
    required this.season,
    required this.number,
    required this.title,
    this.imageUrl,
    this.plot,
    this.duration,
    this.extension = 'mp4',
    this.directUrl,
  });

  /// Episode identifier.
  final int id;

  /// Season number.
  final int season;

  /// Episode number inside the season.
  final int number;

  /// Episode title.
  final String title;

  /// 16:9 still image.
  final String? imageUrl;

  /// Synopsis.
  final String? plot;

  /// Human readable duration.
  final String? duration;

  /// Container extension used to build the URL.
  final String extension;

  /// Playback URL when the source provides it directly (demo).
  final String? directUrl;
}

/// Seasons and episodes of a series.
@immutable
class SeriesDetail {
  /// Creates the detail.
  const new({required this.series, required this.episodesBySeason});

  /// The series.
  final Series series;

  /// Episodes grouped by season number.
  final Map<int, List<Episode>> episodesBySeason;

  /// Season numbers in ascending order.
  List<int> get seasons => episodesBySeason.keys.toList()..sort();
}
