import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/playback_targets.dart';
import 'package:streamora/features/catalog/presentation/series_detail_screen.dart';
import 'package:streamora/features/player/domain/playback.dart';
import 'package:streamora/features/player/presentation/player_providers.dart';
import 'package:streamora/shared/widgets/cards.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// "Continue watching" row. Lives in the app layer because it combines the
/// player's progress with the catalog.
class ContinueWatchingSection extends ConsumerWidget {
  /// Creates the section.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(continueWatchingProvider).value ?? const [];
    if (progress.isEmpty) return const SizedBox.shrink();
    final movies = ref.watch(moviesProvider).value ?? const <Movie>[];
    final hasEpisodes = progress.any((p) => p.kind == PlaybackKind.episode);
    final series = hasEpisodes
        ? ref.watch(seriesListProvider).value ?? const <Series>[]
        : const <Series>[];

    final cards = <Widget>[];
    for (final p in progress) {
      switch (p.kind) {
        case PlaybackKind.movie:
          final movie = movies.where((m) => m.id == p.id).firstOrNull;
          if (movie == null) continue;
          cards.add(
            PosterCard(
              title: movie.title,
              imageUrl: movie.posterUrl,
              subtitle: 'Resume',
              progress: p.fraction,
              onTap: () => play(
                context,
                movieTarget(ref.read(catalogRepositoryProvider), movie),
              ),
            ),
          );
        case PlaybackKind.episode:
          final show = series.where((s) => s.id == p.seriesId).firstOrNull;
          if (show == null) continue;
          cards.add(
            PosterCard(
              title: show.title,
              imageUrl: show.coverUrl,
              subtitle: p.subtitle,
              progress: p.fraction,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SeriesDetailScreen(series: show),
                ),
              ),
            ),
          );
        case PlaybackKind.live:
          break;
      }
    }
    if (cards.isEmpty) return const SizedBox.shrink();
    return SectionRow(
      title: 'Continue watching',
      itemCount: cards.length,
      itemBuilder: (_, i) => cards[i],
    );
  }
}
