import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';

/// Loads the raw demo catalog JSON.
typedef DemoJsonLoader = Future<String> Function();

Future<String> _loadAsset() => rootBundle.loadString('assets/demo/demo.json');

/// [CatalogRepository] backed by the bundled `assets/demo/demo.json`.
class DemoCatalogRepository implements CatalogRepository {
  /// Creates the repository. `loader` is injectable for tests.
  new([this._loader = _loadAsset]);

  final DemoJsonLoader _loader;
  Map<String, dynamic>? _json;
  final Map<int, Map<String, dynamic>> _seriesJson = {};
  final Map<int, Map<String, dynamic>> _movieJson = {};

  Future<Map<String, dynamic>> _section(String name) async {
    _json ??= jsonDecode(await _loader()) as Map<String, dynamic>;
    return _json![name] as Map<String, dynamic>;
  }

  List<MediaCategory> _categories(Map<String, dynamic> section) => [
    for (final c in section['categories'] as List<dynamic>)
      MediaCategory(
        id: (c as Map<String, dynamic>)['id'] as int,
        name: c['name'] as String,
      ),
  ];

  @override
  Future<List<MediaCategory>> liveCategories() async =>
      _categories(await _section('live'));

  @override
  Future<List<LiveChannel>> liveChannels() async {
    final section = await _section('live');
    return [
      for (final i in section['items'] as List<dynamic>)
        LiveChannel(
          id: (i as Map<String, dynamic>)['id'] as int,
          title: i['name'] as String,
          categoryId: i['category'] as int?,
          directUrl: i['url'] as String?,
        ),
    ];
  }

  @override
  Future<List<MediaCategory>> movieCategories() async =>
      _categories(await _section('movies'));

  @override
  Future<List<Movie>> movies() async {
    final section = await _section('movies');
    final result = <Movie>[];
    for (final raw in section['items'] as List<dynamic>) {
      final i = raw as Map<String, dynamic>;
      _movieJson[i['id'] as int] = i;
      result.add(
        Movie(
          id: i['id'] as int,
          title: i['title'] as String,
          categoryId: i['category'] as int?,
          year: i['year']?.toString(),
          rating: (i['rating'] as num?)?.toDouble(),
          posterUrl: i['poster'] as String?,
          directUrl: i['url'] as String?,
          plot: i['plot'] as String?,
          genre: i['genre'] as String?,
        ),
      );
    }
    return result;
  }

  @override
  Future<MovieDetail> movieDetail(Movie movie) async {
    final i = _movieJson[movie.id];
    return MovieDetail(
      plot: i?['plot'] as String?,
      genre: i?['genre'] as String?,
      cast: i?['cast'] as String?,
      director: i?['director'] as String?,
      duration: i?['duration'] as String?,
    );
  }

  @override
  Future<List<MediaCategory>> seriesCategories() async =>
      _categories(await _section('series'));

  @override
  Future<List<Series>> series() async {
    final section = await _section('series');
    final result = <Series>[];
    for (final raw in section['items'] as List<dynamic>) {
      final i = raw as Map<String, dynamic>;
      _seriesJson[i['id'] as int] = i;
      result.add(
        Series(
          id: i['id'] as int,
          title: i['title'] as String,
          categoryId: i['category'] as int?,
          plot: i['plot'] as String?,
          genre: i['genre'] as String?,
          rating: (i['rating'] as num?)?.toDouble(),
          year: i['year']?.toString(),
        ),
      );
    }
    return result;
  }

  @override
  Future<SeriesDetail> seriesDetail(Series series) async {
    final i = _seriesJson[series.id];
    final bySeason = <int, List<Episode>>{};
    for (final rawSeason in (i?['seasons'] as List<dynamic>?) ?? const []) {
      final s = rawSeason as Map<String, dynamic>;
      final number = s['number'] as int;
      bySeason[number] = [
        for (final rawEp in s['episodes'] as List<dynamic>)
          Episode(
            id: (rawEp as Map<String, dynamic>)['id'] as int,
            season: number,
            number: rawEp['number'] as int,
            title: rawEp['title'] as String,
            plot: rawEp['plot'] as String?,
            duration: rawEp['duration'] as String?,
            directUrl: rawEp['url'] as String?,
          ),
      ];
    }
    return SeriesDetail(series: series, episodesBySeason: bySeason);
  }

  @override
  String liveUrl(LiveChannel channel) => channel.directUrl ?? '';

  @override
  String movieUrl(Movie movie) => movie.directUrl ?? '';

  @override
  String episodeUrl(Episode episode) => episode.directUrl ?? '';
}
