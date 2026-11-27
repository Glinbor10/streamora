# Catalog

## Requirement: Sections load independently
Scenario: load live channels
- Given a valid session
- When the live section is requested
- Then categories and channels are returned and cached in memory

Scenario: one section fails
- Given the movies request fails
- When live and series are requested
- Then they still load and movies reports a failure

## Requirement: Series detail
Scenario: open a series
- Given a series from the catalog
- When its detail is requested
- Then seasons with episodes are returned and cached for later requests

## Requirement: Demo catalog
Scenario: demo session
- Given the demo session
- When any section is requested
- Then items come from assets/demo/demo.json without network access to a provider

## Requirement: Playback URL
Scenario: build a URL
- Given an Xtream channel, movie or episode
- When its playback URL is requested
- Then the URL is built by the repository and never exposed in logs
