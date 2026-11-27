import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/catalog/data/xtream_mappers.dart';
import 'package:xtream_code_client/xtream_code_client.dart' as x;

void main() {
  test('categories drop entries without id or name', () {
    final result = XtreamMappers.categories(const [
      x.Category(categoryId: 1, categoryName: ' News '),
      x.Category(categoryId: 2),
      x.Category(categoryName: 'No id'),
    ]);
    expect(result, hasLength(1));
    expect(result.single.name, 'News');
  });

  test('live channels are mapped and nameless ones get a fallback', () {
    final result = XtreamMappers.live(const [
      x.LiveStreamItem(streamId: 5, name: 'One', streamIcon: 'http://a/b.png'),
      x.LiveStreamItem(streamId: 6),
      x.LiveStreamItem(name: 'No id'),
    ]);
    expect(result.map((c) => c.title), ['One', 'Channel 6']);
    expect(result.first.logoUrl, 'http://a/b.png');
  });

  test('movies use container extension and category fallback', () {
    final result = XtreamMappers.movies(const [
      x.VodItem(
        streamId: 9,
        name: 'Film',
        containerExtension: 'mkv',
        categoryIds: [4],
      ),
    ]);
    expect(result.single.extension, 'mkv');
    expect(result.single.categoryId, 4);
  });

  test('series detail groups and sorts episodes by season', () {
    final series = XtreamMappers.series(const [
      x.SeriesItem(seriesId: 1, name: 'Show'),
    ]).single;
    final detail = XtreamMappers.seriesDetail(
      series,
      const x.SeriesInfo(
        seasons: null,
        info: x.SeriesDetails(),
        episodes: {
          '1': [
            x.Episode(id: 12, episodeNum: 2, title: 'B', info: x.EpisodeInfo()),
            x.Episode(id: 11, episodeNum: 1, title: 'A', info: x.EpisodeInfo()),
          ],
          '2': [
            x.Episode(id: 21, episodeNum: 1, title: 'C', info: x.EpisodeInfo()),
          ],
        },
      ),
    );
    expect(detail.seasons, [1, 2]);
    expect(detail.episodesBySeason[1]!.map((e) => e.title), ['A', 'B']);
  });
}
