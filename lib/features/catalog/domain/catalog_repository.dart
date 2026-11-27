import 'package:streamora/features/catalog/domain/media.dart';

/// Read access to the catalog of the current session.
abstract interface class CatalogRepository {
  /// Live TV categories.
  Future<List<MediaCategory>> liveCategories();

  /// All live channels.
  Future<List<LiveChannel>> liveChannels();

  /// Movie categories.
  Future<List<MediaCategory>> movieCategories();

  /// All movies.
  Future<List<Movie>> movies();

  /// Extra information of one movie.
  Future<MovieDetail> movieDetail(Movie movie);

  /// Series categories.
  Future<List<MediaCategory>> seriesCategories();

  /// All series.
  Future<List<Series>> series();

  /// Seasons and episodes of one series.
  Future<SeriesDetail> seriesDetail(Series series);

  /// Playback URL of a channel. Never log it: it can embed credentials.
  String liveUrl(LiveChannel channel);

  /// Playback URL of a movie.
  String movieUrl(Movie movie);

  /// Playback URL of an episode.
  String episodeUrl(Episode episode);
}
