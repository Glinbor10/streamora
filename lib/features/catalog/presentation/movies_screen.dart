import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/catalog_widgets.dart';
import 'package:streamora/features/catalog/presentation/movie_detail_screen.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/cards.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Movies: hero banner, rows by category, filter and search.
class MoviesScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesProvider);
    return movies.when(
      loading: () => const _MoviesSkeleton(),
      error: (_, _) => ErrorView(
        message: 'Could not load movies.',
        onRetry: () => ref.invalidate(moviesProvider),
      ),
      data: (all) => all.isEmpty
          ? const EmptyView(message: 'No movies available.')
          : _MoviesContent(all: all),
    );
  }
}

class _MoviesContent extends ConsumerWidget {
  const new({required this.all});

  final List<Movie> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(movieQueryProvider);
    final notifier = ref.read(movieQueryProvider.notifier);
    final categories =
        ref.watch(movieCategoriesProvider).value ?? const <MediaCategory>[];
    final byCategory = ref.watch(moviesByCategoryProvider);
    final filtered = ref.watch(filteredMoviesProvider).value ?? const [];
    final featured = all.reduce(
      (a, b) => (a.rating ?? 0) >= (b.rating ?? 0) ? a : b,
    );
    final isWide = MediaQuery.sizeOf(context).width >= desktopBreakpoint;

    void open(Movie m) => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => MovieDetailScreen(movie: m)),
    );

    return CustomScrollView(
      slivers: [
        if (query.isEmpty)
          SliverToBoxAdapter(
            child: HeroBanner(
              title: featured.title,
              imageUrl: featured.posterUrl,
              height: isWide ? 460 : 400,
              meta: [
                if (featured.year != null) featured.year!,
                if (featured.rating != null)
                  '${featured.rating!.toStringAsFixed(1)}/10',
                if (featured.genre != null) featured.genre!,
              ].join('  ·  '),
              plot: featured.plot,
              onPlay: () => showPlaybackSoon(context),
              onInfo: () => open(featured),
            ),
          )
        else
          const SliverToBoxAdapter(child: TopPad()),
        SliverToBoxAdapter(
          child: SearchField(
            initialText: query.text,
            onChanged: notifier.setText,
            hint: 'Search movies',
          ),
        ),
        SliverToBoxAdapter(
          child: DomainCategoryChips(
            categories: categories,
            selectedId: query.categoryId,
            onSelected: notifier.selectCategory,
          ),
        ),
        if (query.isEmpty)
          SliverList.builder(
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final cat = categories[i];
              final items = byCategory[cat.id] ?? const <Movie>[];
              if (items.isEmpty) return const SizedBox.shrink();
              return SectionRow(
                title: cat.name,
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final m = items[index];
                  return PosterCard(
                    title: m.title,
                    imageUrl: m.posterUrl,
                    subtitle: [
                      if (m.year != null) m.year!,
                      if (m.rating != null)
                        '${m.rating!.toStringAsFixed(1)}/10',
                    ].join('  ·  '),
                    onTap: () => open(m),
                  );
                },
              );
            },
          )
        else if (filtered.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No movies match your search.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              gridDelegate: posterGridDelegate,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final m = filtered[i];
                return PosterCard(
                  title: m.title,
                  imageUrl: m.posterUrl,
                  subtitle: m.year,
                  onTap: () => open(m),
                );
              },
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _MoviesSkeleton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final movies = placeholderMovies();
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: AppColors.surfaceHigh,
        highlightColor: AppColors.surface,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 380, child: ColoredBox(color: Colors.grey)),
          for (final title in const ['Popular', 'New releases'])
            SectionRow(
              title: title,
              itemCount: movies.length,
              itemBuilder: (_, i) => PosterCard(
                title: movies[i].title,
                subtitle: movies[i].year,
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
