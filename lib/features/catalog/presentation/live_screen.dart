import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/features/catalog/presentation/catalog_providers.dart';
import 'package:streamora/features/catalog/presentation/catalog_widgets.dart';
import 'package:streamora/features/catalog/presentation/playback_targets.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/cards.dart';
import 'package:streamora/shared/widgets/layout.dart';

const _channelGrid = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 220,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 1.25,
);

/// Live TV: category chips, search and a channel grid.
class LiveScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(liveChannelsProvider);
    return all.when(
      loading: () => Skeletonizer(
        effect: const ShimmerEffect(
          baseColor: AppColors.surfaceHigh,
          highlightColor: AppColors.surface,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          gridDelegate: _channelGrid,
          itemCount: 12,
          itemBuilder: (_, _) =>
              ChannelCard(title: 'Loading channel', onTap: () {}),
        ),
      ),
      error: (_, _) => ErrorView(
        message: 'Could not load channels.',
        onRetry: () => ref.invalidate(liveChannelsProvider),
      ),
      data: (items) => items.isEmpty
          ? const EmptyView(message: 'No channels available.')
          : const _LiveContent(),
    );
  }
}

class _LiveContent extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(liveQueryProvider);
    final notifier = ref.read(liveQueryProvider.notifier);
    final categories =
        ref.watch(liveCategoriesProvider).value ?? const <MediaCategory>[];
    final filtered = ref.watch(filteredLiveProvider).value ?? const [];

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: TopPad()),
        SliverToBoxAdapter(
          child: SearchField(
            initialText: query.text,
            onChanged: notifier.setText,
            hint: 'Search channels',
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
            child: EmptyView(message: 'No channels match your search.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              gridDelegate: _channelGrid,
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final c = filtered[i];
                return ChannelCard(
                  title: c.title,
                  logoUrl: c.logoUrl,
                  onTap: () => play(
                    context,
                    liveTarget(ref.read(catalogRepositoryProvider), c),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
