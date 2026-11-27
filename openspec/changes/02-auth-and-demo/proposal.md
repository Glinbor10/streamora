# 02-auth-and-demo: proposal

## What
Login screen (server + username + password), secure credential storage, Xtream authentication, and an offline Demo Mode backed by a local JSON of freely licensed Blender Foundation videos.

## Why
Entry point of the app. Demo Mode lets anyone try the app without a provider account.

## Scope
- Login form with validation and error states; secondary "Demo Mode" button.
- Server URL normalization (scheme, trailing slash, port).
- Credentials stored in flutter_secure_storage; auto-login on start.
- Logout clears credentials.
- go_router with redirect guard (unauthenticated -> /login).
- Riverpod for state.
- Unit and widget tests; no real servers or credentials anywhere.

## Out of scope
Catalog, player, UI polish (phases 3-5).

## Success criteria
- Valid fake-server login reaches the home placeholder; invalid shows a clear error.
- Demo Mode works with no network to any provider.
- Credentials never appear in logs or repo.
- Architecture tests and CI stay green.
