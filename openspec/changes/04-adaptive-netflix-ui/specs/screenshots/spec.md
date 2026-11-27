# Screenshots

## Requirement: Real, current captures
Scenario: README
- Given a release build in Demo Mode
- When screenshots are generated
- Then docs/screenshots contains Windows and Android captures of login, movies, series, live and detail screens, and the README references them

Scenario: no private data
- Given any screenshot
- Then it contains only demo content and no personal or provider data
