# Adaptive UI

## Requirement: Adaptive navigation
Scenario: phone width
- Given a window narrower than 600 px
- When the home screen is shown
- Then a bottom NavigationBar with Live TV, Movies, Series is displayed

Scenario: desktop width
- Given a window of 600 px or wider
- When the home screen is shown
- Then a NavigationRail is displayed instead

## Requirement: Movies section
Scenario: hero and rows
- Given the demo catalog
- When Movies is opened
- Then a hero banner with gradient is shown followed by horizontal genre rows of 2:3 posters

Scenario: detail
- Given a poster
- When tapped
- Then a detail screen with synopsis and a Play button is shown

## Requirement: Series section
Scenario: season selection
- Given a series detail
- When another season is selected
- Then its episodes are shown as 16:9 cards

## Requirement: Live TV
Scenario: category filter
- Given the Live TV section
- When a category chip is selected
- Then only its channels are shown, each with logo and LIVE badge

## Requirement: Loading and errors
Scenario: loading
- Given data is loading
- Then skeleton placeholders with the final layout are shown
