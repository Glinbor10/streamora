import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/catalog_widgets.dart';
import 'package:streamora/features/catalog/presentation/series_detail_screen.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/cards.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Series catalog: category chips, search and a poster grid.
class SeriesScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(seriesListProvider);
    return all.when(
      loading: () => const _SeriesSkeleton(),
      error: (_, _) => ErrorView(
        message: 'Could not load series.',
        onRetry: () => ref.invalidate(seriesListProvider),
      ),
      data: (items) => items.isEmpty
          ? const EmptyView(message: 'No series available.')
          : const _SeriesContent(),
    );
  }
}

class _SeriesContent extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(seriesQueryProvider);
    final notifier = ref.read(seriesQueryProvider.notifier);
    final categories =
        ref.watch(seriesCategoriesProvider).value ?? const <MediaCategory>[];
    final filtered = ref.watch(filteredSeriesProvider).value ?? const [];

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: TopPad()),
        SliverToBoxAdapter(
          child: SearchField(
            initialText: query.text,
            onChanged: notifier.setText,
            hint: 'Search series',
          ),
        ),
        SliverToBoxAdapter(
          child: DomainCategoryChips(
            categories: categories,
            selectedId: query.categoryId,
            onSelected: notifier.selectCategory,
          ),
        ),
        if (filtered.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(message: 'No series match your search.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, shellBottomPadding),
            sliver: SliverGrid.builder(
              gridDelegate: posterGridDelegate,
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final s = filtered[i];
                return PosterCard(
                  title: s.title,
                  imageUrl: s.coverUrl,
                  subtitle: [
                    if (s.year != null) s.year!,
                    if (s.rating != null) '${s.rating!.toStringAsFixed(1)}/10',
                  ].join('  ·  '),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SeriesDetailScreen(series: s),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SeriesSkeleton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: AppColors.surfaceHigh,
        highlightColor: AppColors.surface,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        gridDelegate: posterGridDelegate,
        itemCount: 12,
        itemBuilder: (_, _) =>
            PosterCard(title: 'Loading title', subtitle: '2024', onTap: () {}),
      ),
    );
  }
}
