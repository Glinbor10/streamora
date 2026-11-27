# 05-media-player: design

## Packages (verified on pub.dev)
media_kit 1.2.6, media_kit_video 2.0.1, media_kit_libs_video 1.0.7, shared_preferences 2.5.6.

## Structure
- features/player/domain: PlaybackTarget (id, title, url, kind: live|movie|episode, optional next), WatchProgress, ProgressRepository (abstract), resume logic (pure: resume position, "finished" threshold at 95%).
- features/player/data: PrefsProgressRepository (shared_preferences, one JSON map keyed by kind:id, capped at 200 entries, newest first).
- features/player/presentation: PlayerScreen (Player + VideoController, controls per platform), providers (progress list, continue-watching), ErrorView with retry.
- app/composition wires catalog URLs into PlaybackTarget so features stay decoupled: catalog UI emits a target through a callback/provider owned by player/domain.

## Decisions
- MediaKit.ensureInitialized() in main; one Player per PlayerScreen, disposed on exit.
- Media(url, httpHeaders: {'User-Agent': xtreamUserAgent}) from lib/shared.
- Save progress every 5 s and on pause/dispose; ignore progress under 10 s or over 95% (marked finished and removed from Continue watching).
- Live streams never store progress.
- Controls: MaterialVideoControls on Android, MaterialDesktopVideoControls on Windows via defaultTargetPlatform.
- Never log URLs (they can embed credentials).

## Risks
- libmpv size increases APK/installer size; ship split-per-abi APK if the size is a problem.
- Demo URLs are third-party hosted; failures show the retry state rather than crashing.
