# Auth

## Requirement: URL normalization
Scenario: scheme and slash
- Given the input "example.com:8080/"
- When normalized
- Then the result is "http://example.com:8080"

Scenario: invalid input
- Given an empty or malformed server
- When submitting the form
- Then a validation error is shown and no request is made

## Requirement: Login
Scenario: valid credentials
- Given a reachable server accepting the credentials
- When the user submits
- Then credentials are stored securely and the home screen opens

Scenario: wrong credentials
- Given the server rejects the credentials
- When the user submits
- Then an "invalid credentials" error is shown and nothing is stored

Scenario: unreachable server
- Given no connectivity or a timeout
- When the user submits
- Then a network error with retry is shown

## Requirement: Session persistence
Scenario: auto login
- Given stored valid credentials
- When the app starts
- Then the user lands on home without seeing login

Scenario: logout
- Given an active session
- When the user logs out
- Then stored credentials are deleted and /login is shown
