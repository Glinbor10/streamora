# Brand

## Requirement: Navy and cyan identity
Scenario: theme
- Given the app is running
- Then backgrounds are navy, the accent is electric cyan and no red accent is used (only error and LIVE badge)

## Requirement: App icon
Scenario: launcher
- Given a release build
- Then the Android launcher and the Windows executable show the Streamore play-wave icon

Scenario: in-app logo
- Given the login screen and the app bar
- Then the logo widget renders at the right size without assets
