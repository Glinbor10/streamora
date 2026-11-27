# 03-catalog-and-search: proposal

## What
Domain models and repositories for Live TV, Movies (VOD) and Series (with seasons and episodes), an in-memory catalog cache for 10,000+ items, filtering by category and instant search. Works for both Xtream accounts and Demo Mode.

## Why
The UI (phase 4) and the player (phase 5) need a clean, tested data layer that stays fast on very large catalogs.

## Scope
- Domain: Category, LiveChannel, Movie, Series, Season, Episode, MediaItem contract for playback URLs.
- CatalogRepository (abstract) with Xtream and Demo implementations.
- In-memory cache with lazy per-section loading, refresh and error states.
- Filtering by category and case/accent-insensitive search over the cached list.
- Tests with fictitious JSON fixtures only.

## Out of scope
Any UI beyond what tests need (phase 4), playback (phase 5), EPG, favorites.

## Success criteria
- Loading a 10,000 item fixture and filtering/searching stays under 50 ms on the test machine.
- No real server data in fixtures or tests.
- Architecture tests and CI stay green.
