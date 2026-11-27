# Player

## Requirement: Play a movie or episode
Scenario: start playback
- Given a movie or episode with a playback URL
- When the user taps Play
- Then the player opens and starts playing with the player User-Agent header

Scenario: resume
- Given saved progress of 12 minutes for the item
- When the user plays it again
- Then playback starts at about 12 minutes

Scenario: finished item
- Given the user watched more than 95% of an item
- When the player closes
- Then the item is marked finished and does not appear in Continue watching

## Requirement: Live TV
Scenario: open a channel
- Given a live channel
- When the user taps it
- Then the stream plays and no progress is stored

## Requirement: Next episode
Scenario: episode ends
- Given an episode that is not the last of the series
- When it finishes
- Then the next episode is offered and starts on confirmation

## Requirement: Errors
Scenario: stream cannot be opened
- Given an unreachable or invalid stream
- When playback fails
- Then an error with a Retry button is shown and the app does not crash
