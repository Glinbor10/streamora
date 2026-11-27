# 03-catalog-and-search: design

## Structure (features/catalog)
- domain: models, CatalogRepository, CatalogQuery (category + text), SearchIndex (normalization), failures.
- data: XtreamCatalogRepository (xtream_code_client v2 mappers), DemoCatalogRepository (assets/demo/demo.json), CatalogCache.
- presentation: Riverpod providers only (liveProvider, moviesProvider, seriesProvider, filtered providers). Screens come in phase 4.

## Key decisions
- Domain models are plain immutable Dart classes; xtream types are mapped in data and never leak.
- Playback URLs are produced by the repository (`streamUrl(item)`) so the user agent and credentials stay inside data.
- Cache: one list per section plus a prebuilt normalized-name index (lowercase, accents stripped) so search is a linear scan over strings, no rebuilds of the widget tree.
- Filtering and search are pure functions on the cached list, returned through derived Riverpod providers so only listeners of the result rebuild.
- Series detail (seasons/episodes) is fetched on demand and cached per series.
- Parsing of big payloads relies on xtream_code_client background isolates (lenient mode); warnings are counted, not shown.

## Errors
CatalogFailure: network, unauthorized, parse, empty. Sections load independently so one failing section does not block others.
