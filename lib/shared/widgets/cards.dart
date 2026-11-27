import 'package:material_ui/material_ui.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/artwork.dart';

/// 2:3 poster card used for movies and series.
class PosterCard extends StatelessWidget {
  /// Creates a poster card.
  const new({
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.subtitle,
    this.width = 140,
    super.key,
  });

  /// Item title.
  final String title;

  /// Poster URL, if any.
  final String? imageUrl;

  /// Small line under the poster (year, rating...).
  final String? subtitle;

  /// Card width; height follows the 2:3 ratio.
  final double width;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Artwork(title: title, imageUrl: imageUrl),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 16:9 episode card.
class EpisodeCard extends StatelessWidget {
  /// Creates an episode card.
  const new({
    required this.number,
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.duration,
    this.plot,
    super.key,
  });

  /// Episode number.
  final int number;

  /// Episode title.
  final String title;

  /// Still image URL, if any.
  final String? imageUrl;

  /// Human readable duration.
  final String? duration;

  /// Short synopsis.
  final String? plot;

  /// Called when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Artwork(title: title, imageUrl: imageUrl, showTitle: false),
                    const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white70,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number. $title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (duration != null)
                      Text(
                        duration!,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    if (plot != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        plot!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Square-ish live channel tile with a LIVE badge.
class ChannelCard extends StatelessWidget {
  /// Creates a channel card.
  const new({
    required this.title,
    required this.onTap,
    this.logoUrl,
    super.key,
  });

  /// Channel name.
  final String title;

  /// Logo URL, if any.
  final String? logoUrl;

  /// Called when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Artwork(title: title, imageUrl: logoUrl, showTitle: false),
                  const Positioned(top: 8, left: 8, child: LiveBadge()),
                  const Center(
                    child: Icon(Icons.live_tv, color: Colors.white70, size: 32),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Red "LIVE" pill.
class LiveBadge extends StatelessWidget {
  /// Creates the badge.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          'LIVE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
