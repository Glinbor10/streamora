# Release

## Requirement: Tag-driven release
Scenario: publish a version
- Given main is green
- When a tag v0.1.0 is pushed
- Then a GitHub Release is created with streamora-android-v0.1.0.apk, streamora-windows-v0.1.0-setup.exe, streamora-windows-v0.1.0-portable.zip and generated notes

## Requirement: Protected main
Scenario: direct push
- Given branch protection on main
- When someone pushes directly to main
- Then the push is rejected
