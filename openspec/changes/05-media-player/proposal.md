# 05-media-player: proposal

## What
Video playback for Live TV, movies and series episodes on Android and Windows, a "Continue watching" row backed by local progress, and automatic resume.

## Why
The app is not useful until content can be played. Phases 3 and 4 already expose playback URLs through the catalog repository.

## Scope
- Player screen using media_kit with the built-in material controls (mobile) and desktop controls (Windows).
- User-Agent header injected into every Media (project rule 1).
- Live (.ts / .m3u8) and VOD (.mp4 / .mkv / .avi) playback.
- Progress persistence (position, duration, last watched) in shared_preferences; resume prompt-free from the saved position.
- "Continue watching" row at the top of Movies, plus next-episode jump for series.
- Wire the existing Play buttons and episode/channel taps.
- Error state with retry when a stream fails to open.

## Out of scope
Subtitles/audio track menus beyond the built-in controls, Chromecast, downloads, EPG, picture-in-picture.

## Success criteria
- Demo Mode plays the Blender sample streams on Windows and Android.
- Closing and reopening an item resumes within a few seconds of where it stopped.
- Finishing an episode offers the next one.
- Unit tests for the progress store and domain logic; CI green; release builds include libmpv.

## Notes
media_kit_libs_video bundles libmpv (LGPL). The README and release notes must credit it and keep the dynamic linking that the LGPL requires.
