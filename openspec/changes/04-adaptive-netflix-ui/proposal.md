# 04-adaptive-netflix-ui: proposal

## What
A polished Netflix-style dark UI with adaptive navigation (bottom bar on phones, rail on desktop), three sections (Live TV, Movies, Series), hero banner, horizontal genre rows, detail screens and skeleton loading. Demo Mode shows a rich, realistic catalog so the app and the README screenshots look like a real session.

## Why
Frontend quality is the top priority of the project and the main thing people see on the repo and on LinkedIn.

## Scope
- Design system: dark cinematic theme, typography scale, spacing, poster/card components (2:3 posters, 16:9 episode cards).
- Adaptive shell: NavigationBar below 600 px, NavigationRail from 600 px.
- Live TV: category chips + channel grid/list with logo and LIVE badge.
- Movies: hero banner with dark gradient + horizontal rows by genre + detail screen.
- Series: catalog + detail with season selector and episode cards.
- Skeletonizer loading states, error and empty states, cached_network_image for artwork.
- Mouse drag scroll on Windows (already in AppScrollBehavior).
- Demo catalog: richer demo.json with generated artwork (original, copyright-free) alongside Blender films.
- Screenshot pipeline: repeatable Windows and Android captures of the demo session saved under docs/screenshots and used in the README.

## Out of scope
Playback (phase 5), EPG, favorites.

## Success criteria
- Demo Mode on Windows and on an Android emulator shows hero, rows and detail screens with artwork.
- No layout overflow at 360 px, 600 px and 1280 px widths (widget tests at those sizes).
- README shows current screenshots for both platforms.
