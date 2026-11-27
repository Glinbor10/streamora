# streamora

Generic OTT player (Flutter) for Android and Windows with a Netflix-like UI.
No preconfigured content or provider data. MIT licensed.

## Conventions
- Code, comments and commits in English.
- Structure: lib/features/{auth,catalog,player}, lib/shared.
- Never commit real server URLs, credentials or keystores.
- Every phase starts with an OpenSpec change in openspec/changes/<name>/.
- Releases are built by the Release workflow on `v*` tags.
