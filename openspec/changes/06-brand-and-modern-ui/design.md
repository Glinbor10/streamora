# 06-brand-and-modern-ui: design

## Theme
AppColors gets the navy/cyan tokens; AppTheme maps them to ColorScheme (primary = cyan, onPrimary = navy). Components read colors from the theme where possible so a future palette change touches one file.

## Logo
`StreamoraLogo` (shared/widgets/logo.dart): a CustomPainter drawing a rounded play triangle built from two offset wave strokes; takes size and color. A test renders it to PNG (same technique as test/screenshots) to produce `assets/brand/icon-1024.png` and a foreground-only variant for the Android adaptive icon; `flutter_launcher_icons` generates Android and Windows icons from them.

## Navigation
- Phone: `FloatingPillNavBar` (shared/widgets) placed in the Scaffold bottom with margin, ClipRRect + BackdropFilter blur, AnimatedContainer indicator. Content gets bottom padding so lists scroll under it.
- Desktop: slim `NavigationRail` replaced by `IconRail` (64 px) with tooltips, selected pill indicator in cyan at 20 percent, logo on top, sign-out at the bottom.
- Breakpoint stays at 600 px; shell tests extended to check both widgets.

## Content-first layout (Stremio-inspired)
Poster rows get slightly larger posters and tighter metadata; hero banner gets a full-bleed navy gradient; section titles lighter weight; fewer borders.

## Risks
- BackdropFilter cost on low-end Android: keep blur radius small and make it optional via a constant.
- App icon generation depends on a package; the generated files are committed so builds do not need it.
