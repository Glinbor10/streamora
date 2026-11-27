import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/playback_targets.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/artwork.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Detail page of a movie with synopsis and Play button.
class MovieDetailScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({required this.movie, super.key});

  /// The movie to show.
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(movieDetailProvider(movie)).value;
    final plot = detail?.plot ?? movie.plot;
    final genre = detail?.genre ?? movie.genre;
    final isWide = MediaQuery.sizeOf(context).width >= desktopBreakpoint;
    final meta = [
      if (movie.year != null) movie.year!,
      if (movie.rating != null) '${movie.rating!.toStringAsFixed(1)}/10',
      ?genre,
      if (detail?.duration != null) detail!.duration!,
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
            height: isWide ? 420 : 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Artwork(
                  title: movie.title,
                  imageUrl: detail?.backdropUrl ?? movie.posterUrl,
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
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(meta, style: const TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => play(
                    context,
                    movieTarget(ref.read(catalogRepositoryProvider), movie),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
                if (plot != null) ...[
                  const SizedBox(height: 20),
                  Text(plot, style: const TextStyle(height: 1.4)),
                ],
                if (detail?.cast != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Cast: ${detail!.cast}',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
                if (detail?.director != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Director: ${detail!.director}',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
