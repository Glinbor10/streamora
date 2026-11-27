import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/features/catalog/domain/catalog_query.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/shared/text_normalizer.dart';

List<Movie> _movies(int count) => [
  for (var i = 0; i < count; i++)
    Movie(
      id: i,
      title: i == 7 ? 'Película Épica' : 'Movie number $i',
      categoryId: i % 10,
    ),
];

void main() {
  test('normalizer lowercases and strips accents', () {
    expect(
      TextNormalizer.normalize('  Película ÉPICA ñandú '),
      'pelicula epica nandu',
    );
  });

  test('empty query returns the same list', () {
    final items = _movies(20);
    expect(
      identical(filterEntries(items, const CatalogQuery()), items),
      isTrue,
    );
  });

  test('search ignores case and accents', () {
    final result = filterEntries(
      _movies(20),
      const CatalogQuery(text: 'pelicula epica'),
    );
    expect(result.map((m) => m.id), [7]);
  });

  test('category filter keeps only that category', () {
    final result = filterEntries(
      _movies(100),
      const CatalogQuery(categoryId: 3),
    );
    expect(result, hasLength(10));
    expect(result.every((m) => m.categoryId == 3), isTrue);
  });

  test('category and text combine', () {
    final result = filterEntries(
      _movies(100),
      const CatalogQuery(categoryId: 3, text: 'number 13'),
    );
    expect(result.map((m) => m.id), [13]);
  });

  test('10,000 items filter and search stay fast', () {
    final items = _movies(10000);
    final watch = Stopwatch()..start();
    final result = filterEntries(
      items,
      const CatalogQuery(categoryId: 4, text: 'number 99'),
    );
    watch.stop();
    expect(result, isNotEmpty);
    expect(watch.elapsedMilliseconds, lessThan(50));
  });
}
