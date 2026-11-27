# streamora

Generic OTT player with a Netflix-style UI for **Android** and **Windows**, built with Flutter.

> Work in progress. No content is bundled; a **Demo Mode** with freely licensed Blender Foundation videos is planned.

## Download
Installable builds are published in [GitHub Releases](../../releases):
- `streamora-android-vX.Y.Z.apk`
- `streamora-windows-vX.Y.Z-setup.exe` (installer) and `...-portable.zip`

## Architecture
`lib/features/<feature>/{domain,data,presentation}` plus `lib/shared`.
Layer rules are enforced by `test/architecture/layers_test.dart` and CI.

## Development
```
flutter pub get
flutter analyze --fatal-infos
flutter test
```
Changes are specified first with OpenSpec in `openspec/changes/`.

## License
Proprietary, all rights reserved. The source is visible but may not be used, copied, modified, distributed or monetized without written permission. See [LICENSE](LICENSE).
