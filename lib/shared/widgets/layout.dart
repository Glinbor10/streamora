import 'package:material_ui/material_ui.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/artwork.dart';

/// Space kept at the end of scrollables so the floating bar never hides
/// the last row.
const shellBottomPadding = 100.0;

/// Width from which the desktop layout (navigation rail) is used.
const desktopBreakpoint = 600.0;

/// Section title followed by a horizontally scrolling row of cards.
class SectionRow extends StatelessWidget {
  /// Creates a row of `itemCount` items built lazily.
  const new({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 270,
    super.key,
  });

  /// Row title.
  final String title;

  /// Number of items.
  final int itemCount;

  /// Builds item `index`.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Row height (must fit the tallest item).
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            scrollCacheExtent: const ScrollCacheExtent.pixels(600),
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}

/// Horizontal category filter chips with an "All" entry.
class CategoryChips extends StatelessWidget {
  /// Creates the chips.
  const new({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  /// Available categories as (id, name).
  final List<({int id, String name})> categories;

  /// Selected category id, null for All.
  final int? selectedId;

  /// Called with the new selection (null for All).
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip('All', selectedId == null, () => onSelected(null)),
          for (final c in categories)
            _chip(c.name, selectedId == c.id, () => onSelected(c.id)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    ),
  );
}

/// Large featured banner with a dark gradient and call-to-action buttons.
class HeroBanner extends StatelessWidget {
  /// Creates the banner.
  const new({
    required this.title,
    required this.onPlay,
    required this.onInfo,
    this.imageUrl,
    this.meta,
    this.plot,
    this.height = 380,
    super.key,
  });

  /// Featured title.
  final String title;

  /// Background image, if any.
  final String? imageUrl;

  /// Line such as "2024 · 8.4 · Sci-Fi".
  final String? meta;

  /// Short synopsis.
  final String? plot;

  /// Banner height.
  final double height;

  /// Play button action.
  final VoidCallback onPlay;

  /// More-info button action.
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Artwork(title: title, imageUrl: imageUrl, showTitle: false),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  AppColors.background,
                ],
                stops: [0, 0.35, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  if (meta != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      meta!,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                  if (plot != null) ...[
                    const SizedBox(height: 8),
                    Text(plot!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: onPlay,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: onInfo,
                        icon: const Icon(Icons.info_outline),
                        label: const Text('More info'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered error message with a retry button.
class ErrorView extends StatelessWidget {
  /// Creates the view.
  const new({required this.message, required this.onRetry, super.key});

  /// What went wrong, in plain language.
  final String message;

  /// Retry action.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

/// Centered "nothing here" message.
class EmptyView extends StatelessWidget {
  /// Creates the view.
  const new({required this.message, super.key});

  /// Explanation shown to the user.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
