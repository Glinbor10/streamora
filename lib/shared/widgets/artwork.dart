import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

/// Artwork that shows [imageUrl] when available and otherwise a gradient
/// generated from [title], so catalogs without images still look designed.
class Artwork extends StatelessWidget {
  /// Creates artwork.
  const new({
    required this.title,
    this.imageUrl,
    this.showTitle = true,
    this.fit = BoxFit.cover,
    super.key,
  });

  /// Used to derive the generated gradient and the printed title.
  final String title;

  /// Remote image, if any.
  final String? imageUrl;

  /// Whether the generated fallback prints the title.
  final bool showTitle;

  /// How a remote image fills the box.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = _Generated(title: title, showTitle: showTitle);
    final url = imageUrl;
    if (url == null || url.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (_, _) => fallback,
      errorWidget: (_, _, _) => fallback,
    );
  }
}

class _Generated extends StatelessWidget {
  const new({required this.title, required this.showTitle});

  final String title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final hash = title.codeUnits.fold<int>(
      7,
      (h, c) => (h * 31 + c) & 0xFFFFFF,
    );
    final hue = 195 + (hash % 70).toDouble();
    final top = HSLColor.fromAHSL(1, hue, 0.55, 0.32).toColor();
    final bottom = HSLColor.fromAHSL(1, (hue + 30) % 360, 0.6, 0.12).toColor();
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ),
      ),
      child: showTitle
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    height: 1.15,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
