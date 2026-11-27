import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamora/features/catalog/domain/catalog_query.dart';
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/domain/media.dart';

/// The repository of the current session. Overridden by the app composition.
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => throw UnimplementedError('catalogRepositoryProvider not provided'),
);

/// Live TV categories.
final liveCategoriesProvider = FutureProvider<List<MediaCategory>>(
  (ref) => ref.watch(catalogRepositoryProvider).liveCategories(),
);

/// All live channels.
final liveChannelsProvider = FutureProvider<List<LiveChannel>>(
  (ref) => ref.watch(catalogRepositoryProvider).liveChannels(),
);

/// Movie categories.
final movieCategoriesProvider = FutureProvider<List<MediaCategory>>(
  (ref) => ref.watch(catalogRepositoryProvider).movieCategories(),
);

/// All movies.
final moviesProvider = FutureProvider<List<Movie>>(
  (ref) => ref.watch(catalogRepositoryProvider).movies(),
);

/// Series categories.
final seriesCategoriesProvider = FutureProvider<List<MediaCategory>>(
  (ref) => ref.watch(catalogRepositoryProvider).seriesCategories(),
);

/// All series.
final seriesListProvider = FutureProvider<List<Series>>(
  (ref) => ref.watch(catalogRepositoryProvider).series(),
);

/// Extra information of a movie.
// ignore: specify_nonobvious_property_types
final movieDetailProvider = FutureProvider.family<MovieDetail, Movie>(
  (ref, movie) => ref.watch(catalogRepositoryProvider).movieDetail(movie),
);

/// Seasons and episodes of a series.
// ignore: specify_nonobvious_property_types
final seriesDetailProvider = FutureProvider.family<SeriesDetail, Series>(
  (ref, series) => ref.watch(catalogRepositoryProvider).seriesDetail(series),
);

/// Holds the category and text filter of one section.
class CatalogQueryNotifier extends Notifier<CatalogQuery> {
  @override
  CatalogQuery build() => const CatalogQuery();

  /// Selects a category (null for all).
  void selectCategory(int? id) => state = state.withCategory(id);

  /// Sets the search text.
  void setText(String text) => state = state.withText(text);
}

/// Filter of the Live TV section.
final liveQueryProvider = NotifierProvider<CatalogQueryNotifier, CatalogQuery>(
  CatalogQueryNotifier.new,
);

/// Filter of the Movies section.
final movieQueryProvider = NotifierProvider<CatalogQueryNotifier, CatalogQuery>(
  CatalogQueryNotifier.new,
);

/// Filter of the Series section.
final seriesQueryProvider =
    NotifierProvider<CatalogQueryNotifier, CatalogQuery>(
      CatalogQueryNotifier.new,
    );

/// Live channels after applying [liveQueryProvider].
final filteredLiveProvider = Provider<AsyncValue<List<LiveChannel>>>((ref) {
  final query = ref.watch(liveQueryProvider);
  return ref
      .watch(liveChannelsProvider)
      .whenData((items) => filterEntries(items, query));
});

/// Movies after applying [movieQueryProvider].
final filteredMoviesProvider = Provider<AsyncValue<List<Movie>>>((ref) {
  final query = ref.watch(movieQueryProvider);
  return ref
      .watch(moviesProvider)
      .whenData((items) => filterEntries(items, query));
});

/// Series after applying [seriesQueryProvider].
final filteredSeriesProvider = Provider<AsyncValue<List<Series>>>((ref) {
  final query = ref.watch(seriesQueryProvider);
  return ref
      .watch(seriesListProvider)
      .whenData((items) => filterEntries(items, query));
});

/// Movies grouped by category id, for the category rows.
final moviesByCategoryProvider = Provider<Map<int, List<Movie>>>((ref) {
  final movies = ref.watch(moviesProvider).value ?? const <Movie>[];
  final result = <int, List<Movie>>{};
  for (final m in movies) {
    final id = m.categoryId;
    if (id != null) (result[id] ??= []).add(m);
  }
  return result;
});
