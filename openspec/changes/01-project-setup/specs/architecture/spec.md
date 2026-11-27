# Architecture

## Requirement: Layer isolation
Scenario: domain imports Flutter
- Given a file under lib/features/*/domain
- When it imports package:flutter or a data/presentation file
- Then the architecture test fails and CI blocks the PR

Scenario: cross-feature coupling
- Given a file in features/catalog/presentation
- When it imports features/player/data
- Then the architecture test fails

Scenario: shared depends on features
- Given a file under lib/shared
- When it imports lib/features
- Then the architecture test fails
