# 02-auth-and-demo: design

## Packages (verified on pub.dev)
- xtream_code_client ^2.0.1 (Xtream API, lenient parsing)
- flutter_riverpod ^3.5.0 (state)
- go_router ^18.1.4 (navigation + guard)
- flutter_secure_storage ^11.2.0 (credentials)

## Structure (features/auth)
- domain: Credentials, AuthSession (sealed: xtream | demo), AuthRepository (abstract), UrlNormalizer.
- data: XtreamAuthRepository (xtream_code_client), SecureCredentialStore, DemoAuthRepository (asset JSON).
- presentation: LoginScreen, authControllerProvider (AsyncNotifier), router redirect.

## Flow
start -> read stored credentials -> (found: authenticate -> home | not found/failed: /login)
login submit -> normalize URL -> authenticate -> store -> home
demo -> AuthSession.demo -> home (no storage write)

## Decisions
- User-Agent set on the Xtream HTTP client (rule 1 of the project plan).
- Domain layer stays pure Dart; xtream types are mapped in data.
- Demo data: assets/demo/demo.json, only Blender Foundation open movies with their license noted.
- Errors mapped to typed failures: invalidUrl, network, unauthorized, expiredAccount, unknown.
