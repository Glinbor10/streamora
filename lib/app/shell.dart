import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/app/continue_watching.dart';
import 'package:streamora/app/session_cleanup.dart';
import 'package:streamora/features/catalog/presentation/live_screen.dart';
import 'package:streamora/features/catalog/presentation/movies_screen.dart';
import 'package:streamora/features/catalog/presentation/series_screen.dart';
import 'package:streamora/shared/theme/app_theme.dart';
import 'package:streamora/shared/widgets/layout.dart';
import 'package:streamora/shared/widgets/logo.dart';
import 'package:streamora/shared/widgets/nav.dart';

/// Adaptive home: floating pill bar on phones, slim icon rail on wide
/// windows.
class AdaptiveShell extends ConsumerStatefulWidget {
  /// Creates the shell.
  const new({super.key});

  @override
  ConsumerState<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends ConsumerState<AdaptiveShell> {
  int _index = 1;
  final Set<int> _visited = {1};

  static const List<NavItem> _items = [
    NavItem(
      id: 'live',
      label: 'Live TV',
      icon: Icons.live_tv_outlined,
      selectedIcon: Icons.live_tv,
    ),
    NavItem(
      id: 'movies',
      label: 'Movies',
      icon: Icons.movie_outlined,
      selectedIcon: Icons.movie,
    ),
    NavItem(
      id: 'series',
      label: 'Series',
      icon: Icons.tv_outlined,
      selectedIcon: Icons.tv,
    ),
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

    if (isWide) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: Row(
          children: [
            IconRail(
              items: _items,
              selectedIndex: _index,
              onSelected: _select,
              onLogout: () => signOut(ProviderScope.containerOf(context)),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamoraLogo(size: 30),
            SizedBox(width: 8),
            Text(
              'streamora',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('logout'),
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(ProviderScope.containerOf(context)),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: FloatingPillNavBar(
        items: _items,
        selectedIndex: _index,
        onSelected: _select,
      ),
    );
  }
}
