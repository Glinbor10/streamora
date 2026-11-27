import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/catalog/data/demo_catalog_repository.dart';
import 'package:streamora/features/catalog/data/xtream_catalog_repository.dart';
import 'package:streamora/features/catalog/domain/cached_catalog_repository.dart';
import 'package:streamora/features/catalog/domain/catalog_repository.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';

/// Builds the catalog repository that matches the current auth session.
CatalogRepository buildCatalogRepository(Ref ref) {
  final session = ref.watch(authControllerProvider).value;
  return CachedCatalogRepository(switch (session) {
    XtreamSession(:final credentials) => XtreamCatalogRepository(credentials),
    DemoSession() => DemoCatalogRepository(),
    null => throw StateError('No active session'),
  });
}

/// Wires features together. This is the only place that knows several
/// features at once.
final List<Override> appOverrides = [
  catalogRepositoryProvider.overrideWith(buildCatalogRepository),
];
