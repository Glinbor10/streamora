import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/logo.dart';

/// Set to false to skip the blur behind the floating bar (low-end devices).
const enableNavBlur = true;

/// One entry of the main navigation.
class NavItem {
  /// Creates an entry. [id] is used to build stable widget keys.
  const new({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// Short identifier, e.g. `movies`.
  final String id;

  /// Human readable label (also used as tooltip).
  final String label;

  /// Icon when not selected.
  final IconData icon;

  /// Icon when selected.
  final IconData selectedIcon;
}

/// Floating, rounded navigation bar for phones (Revolut / Trade Republic
/// style): the selected item expands into a cyan pill with its label.
class FloatingPillNavBar extends StatelessWidget {
  /// Creates the bar.
  const new({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// Entries to show.
  final List<NavItem> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                flex: i == selectedIndex ? 5 : 3,
                child: _PillItem(
                  item: items[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
              ),
          ],
        ),
      ),
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: enableNavBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: bar,
                )
              : bar,
        ),
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  const new({required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.label,
      child: InkWell(
        key: Key('nav-${item.id}'),
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 52,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: selected ? AppColors.accent : AppColors.textMuted,
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Slim icon-only navigation rail for wide windows (Stremio style).
class IconRail extends StatelessWidget {
  /// Creates the rail.
  const new({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.onLogout,
    super.key,
  });

  /// Entries to show.
  final List<NavItem> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onSelected;

  /// Called when the sign-out button is pressed.
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      color: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const StreamoraLogo(size: 36),
            const SizedBox(height: 28),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _RailButton(
                  item: items[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
              ),
            const Spacer(),
            Tooltip(
              message: 'Sign out',
              child: IconButton(
                key: const Key('logout'),
                icon: const Icon(Icons.logout, color: AppColors.textMuted),
                onPressed: onLogout,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const new({required this.item, required this.selected, required this.onTap});

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.label,
      child: InkWell(
        key: Key('nav-${item.id}'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            selected ? item.selectedIcon : item.icon,
            color: selected ? AppColors.accent : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
