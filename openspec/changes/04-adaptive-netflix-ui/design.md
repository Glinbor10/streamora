# 04-adaptive-netflix-ui: design

## Packages
cached_network_image, skeletonizer (both named in the project plan). Everything else is Flutter/material_ui.

## Structure
- shared/theme: AppTheme (colors, text styles), shared/widgets: PosterCard, EpisodeCard, HeroBanner, SectionRow, CategoryChips, LiveBadge, ErrorView.
- app/shell: AdaptiveShell (LayoutBuilder, breakpoint 600).
- features/catalog/presentation: live, movies, series screens and detail screens built on the providers from phase 3.

## Decisions
- Color: near-black surfaces, one red accent; poster images with rounded corners and subtle gradient scrims for text legibility.
- Rows use ListView.builder with bounded cacheExtent; vertical page uses a CustomScrollView with slivers.
- Loading uses Skeletonizer over the same widgets with placeholder data to avoid layout jumps.
- Demo artwork: generated original posters/backdrops (gradient + title typography) stored as assets, so screenshots never use copyrighted images.
- Screenshots: Windows via the release build window capture; Android via an emulator (system image installed with sdkmanager) driven with flutter drive / adb screencap. If the emulator cannot run on this machine, phone-size captures of the real layout are labeled as such.
