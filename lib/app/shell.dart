import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/app/continue_watching.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/catalog/presentation/live_screen.dart';
import 'package:streamora/features/catalog/presentation/movies_screen.dart';
import 'package:streamora/features/catalog/presentation/series_screen.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Adaptive home: bottom bar on phones, navigation rail on wider windows.
class AdaptiveShell extends ConsumerStatefulWidget {
  /// Creates the shell.
  const new({super.key});

  @override
  ConsumerState<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends ConsumerState<AdaptiveShell> {
  int _index = 1;
  final Set<int> _visited = {1};

  static const List<({IconData icon, String label, IconData selected})>
  _destinations = [
    (icon: Icons.live_tv_outlined, selected: Icons.live_tv, label: 'Live TV'),
    (icon: Icons.movie_outlined, selected: Icons.movie, label: 'Movies'),
    (icon: Icons.tv_outlined, selected: Icons.tv, label: 'Series'),
  ];

  static const List<Widget> _screens = [
    LiveScreen(),
    MoviesScreen(continueWatching: ContinueWatchingSection()),
    SeriesScreen(),
  ];

  void _select(int i) => setState(() {
    _index = i;
    _visited.add(i);
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= desktopBreakpoint;
    final body = IndexedStack(
      index: _index,
      children: [
        for (var i = 0; i < _screens.length; i++)
          if (_visited.contains(i)) _screens[i] else const SizedBox.shrink(),
      ],
    );

    final appBar = AppBar(
      title: const Text(
        'STREAMORA',
        style: TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      actions: [
        IconButton(
          key: const Key('logout'),
          tooltip: 'Sign out',
          icon: const Icon(Icons.logout),
          onPressed: ref.read(authControllerProvider.notifier).logout,
        ),
      ],
    );

    if (isWide) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selected),
                    label: Text(d.label),
                  ),
              ],
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected),
              label: d.label,
            ),
        ],
      ),
    );
  }
}
