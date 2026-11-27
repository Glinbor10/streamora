# Demo Mode

## Requirement: Offline demo
Scenario: enter demo
- Given the login screen
- When the user taps "Demo Mode"
- Then the app opens with the bundled demo catalog and nothing is persisted

Scenario: demo content
- Given assets/demo/demo.json
- When loaded
- Then every entry is a freely licensed Blender Foundation video with title, poster URL and stream URL
