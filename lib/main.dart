import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:streamora/app/composition.dart';
import 'package:streamora/app/router.dart';
import 'package:streamora/shared/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(ProviderScope(overrides: appOverrides, child: const StreamoraApp()));
}

/// Lets mouse and touch drag scrollables (needed on Windows).
class AppScrollBehavior extends MaterialScrollBehavior {
  /// Creates the behavior.
  const new();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };
}

/// Root widget of the streamora application.
class StreamoraApp extends ConsumerWidget {
  /// Creates the root widget.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'streamora',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.dark(),
    );
  }
}
