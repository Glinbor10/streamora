# Continue watching

Scenario: row appears
- Given at least one item with progress between 10 s and 95%
- When Movies is opened
- Then a "Continue watching" row shows them, most recent first, with a progress bar

Scenario: capped history
- Given more than 200 stored items
- When a new progress is saved
- Then the oldest entries are dropped

Scenario: demo isolation
- Given a Demo session
- When progress is saved
- Then it is stored locally and never sent anywhere
