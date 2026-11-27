import 'package:streamora/features/auth/domain/credentials.dart';
import 'package:streamora/features/catalog/data/xtream_mappers.dart';
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/shared/user_agent_client.dart';
import 'package:xtream_code_client/xtream_code_client.dart' as x;

/// [CatalogRepository] backed by an Xtream server.
class XtreamCatalogRepository implements CatalogRepository {
  /// Creates a repository for [credentials].
  new(Credentials credentials)
    : _client = x.XtreamClient(
        url: credentials.server,
        username: credentials.username,
        password: credentials.password,
        httpClient: UserAgentClient(),
      );

  final x.XtreamClient _client;
  final Map<int, x.VodItem> _vodById = {};
  final Map<int, x.SeriesItem> _seriesById = {};

  @override
  Future<List<MediaCategory>> liveCategories() async =>
      XtreamMappers.categories(await _client.liveStreamCategoriesData());

  @override
  Future<List<LiveChannel>> liveChannels() async =>
      XtreamMappers.live(await _client.liveStreamItemsData());

  @override
  Future<List<MediaCategory>> movieCategories() async =>
      XtreamMappers.categories(await _client.vodCategoriesData());

  @override
  Future<List<Movie>> movies() async {
    final raw = await _client.vodItemsData();
    for (final item in raw) {
      if (item.streamId != null) _vodById[item.streamId!] = item;
    }
    return XtreamMappers.movies(raw);
  }

  @override
  Future<MovieDetail> movieDetail(Movie movie) async {
    final item = _vodById[movie.id];
    if (item == null) return const MovieDetail();
    return XtreamMappers.movieDetail(await _client.vodInfoData(item));
  }

  @override
  Future<List<MediaCategory>> seriesCategories() async =>
      XtreamMappers.categories(await _client.seriesCategoriesData());

  @override
  Future<List<Series>> series() async {
    final raw = await _client.seriesItemsData();
    for (final item in raw) {
      if (item.seriesId != null) _seriesById[item.seriesId!] = item;
    }
    return XtreamMappers.series(raw);
  }

  @override
  Future<SeriesDetail> seriesDetail(Series series) async {
    final item = _seriesById[series.id];
    if (item == null) {
      return SeriesDetail(series: series, episodesBySeason: const {});
    }
    return XtreamMappers.seriesDetail(
      series,
      await _client.seriesInfoData(item),
    );
  }

  @override
  String liveUrl(LiveChannel channel) =>
      _client.streamUrl(channel.id, const ['ts', 'm3u8']);

  @override
  String movieUrl(Movie movie) => _client.movieUrl(movie.id, movie.extension);

  @override
  String episodeUrl(Episode episode) =>
      _client.seriesUrl(episode.id, episode.extension);
}
