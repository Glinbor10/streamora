import 'package:meta/meta.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/shared/text_normalizer.dart';

/// Category and text filter applied to a section.
@immutable
class CatalogQuery {
  /// Creates a query. Both parts are optional.
  const new({this.categoryId, this.text = ''});

  /// Selected category, or null for all.
  final int? categoryId;

  /// Raw search text.
  final String text;

  /// True when the query does not filter anything.
  bool get isEmpty => categoryId == null && text.trim().isEmpty;

  /// Copy with a different category (null clears it).
  CatalogQuery withCategory(int? id) =>
      CatalogQuery(categoryId: id, text: text);

  /// Copy with different search text.
  CatalogQuery withText(String value) =>
      CatalogQuery(categoryId: categoryId, text: value);
}

/// Returns the entries of [items] that satisfy [query].
///
/// A linear scan over precomputed search keys: no allocations per item.
List<T> filterEntries<T extends CatalogEntry>(
  List<T> items,
  CatalogQuery query,
) {
  if (query.isEmpty) return items;
  final needle = TextNormalizer.normalize(query.text);
  final category = query.categoryId;
  return [
    for (final item in items)
      if ((category == null || item.categoryId == category) &&
          (needle.isEmpty || item.searchKey.contains(needle)))
        item,
  ];
}
