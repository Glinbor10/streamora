import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/auth/domain/auth_session.dart';
import 'package:streamora/features/auth/presentation/auth_providers.dart';
import 'package:streamora/features/auth/presentation/login_screen.dart';

/// Application router with an authentication guard.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(authControllerProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      if (auth.isLoading) return location == '/splash' ? null : '/splash';
      final loggedIn = auth.value != null;
      if (!loggedIn) return location == '/login' ? null : '/login';
      return (location == '/login' || location == '/splash') ? '/' : null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/', builder: (_, _) => const _HomePlaceholder()),
    ],
  );
});

class _HomePlaceholder extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).value;
    final label = switch (session) {
      DemoSession() => 'Demo Mode',
      XtreamSession() => 'Signed in',
      null => '',
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('streamora'),
        actions: [
          IconButton(
            key: const Key('logout'),
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: ref.read(authControllerProvider.notifier).logout,
          ),
        ],
      ),
      body: Center(child: Text(label)),
    );
  }
}
