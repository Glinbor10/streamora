# Player hardening

Scenario: protocol whitelist
- Given the player is created
- Then its configuration allows only tcp, tls, http, https and crypto
