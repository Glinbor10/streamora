# Session hygiene

Scenario: logout clears local state
- Given an active session with watch progress and cached artwork
- When the user signs out
- Then progress entries and the image cache are cleared and Continue watching is empty after the next login

Scenario: strict account check
- Given a server that answers 200 without auth == true
- When the user signs in
- Then login fails with an invalid-credentials error and nothing is stored
