import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/catalog_widgets.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/artwork.dart';
import 'package:streamora/shared/widgets/cards.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Series detail with a season selector and 16:9 episode cards.
class SeriesDetailScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const new({required this.series, super.key});

  /// The series to show.
  final Series series;

  @override
  ConsumerState<SeriesDetailScreen> createState() => _SeriesDetailState();
}

class _SeriesDetailState extends ConsumerState<SeriesDetailScreen> {
  int? _season;

  @override
  Widget build(BuildContext context) {
    final series = widget.series;
    final detail = ref.watch(seriesDetailProvider(series));
    final isWide = MediaQuery.sizeOf(context).width >= desktopBreakpoint;
    final meta = [
      if (series.year != null) series.year!,
      if (series.rating != null) '${series.rating!.toStringAsFixed(1)}/10',
      if (series.genre != null) series.genre!,
    ].join('  ·  ');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: isWide ? 380 : 280,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Artwork(
                  title: series.title,
                  imageUrl: series.backdropUrl ?? series.coverUrl,
                  showTitle: false,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), AppColors.background],
                      stops: [0.4, 1],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.title,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(meta, style: const TextStyle(color: AppColors.textMuted)),
                if (series.plot != null) ...[
                  const SizedBox(height: 12),
                  Text(series.plot!, style: const TextStyle(height: 1.4)),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
          detail.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => SizedBox(
              height: 220,
              child: ErrorView(
                message: 'Could not load episodes.',
                onRetry: () => ref.invalidate(seriesDetailProvider(series)),
              ),
            ),
            data: (d) {
              if (d.seasons.isEmpty) {
                return const SizedBox(
                  height: 160,
                  child: EmptyView(message: 'No episodes available.'),
                );
              }
              final selected = d.seasons.contains(_season)
                  ? _season!
                  : d.seasons.first;
              final episodes = d.episodesBySeason[selected] ?? const [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (final s in d.seasons)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('Season $s'),
                              selected: s == selected,
                              showCheckmark: false,
                              onSelected: (_) => setState(() => _season = s),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final e in episodes)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: EpisodeCard(
                        number: e.number,
                        title: e.title,
                        imageUrl: e.imageUrl,
                        duration: e.duration,
                        plot: e.plot,
                        onTap: () => showPlaybackSoon(context),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
