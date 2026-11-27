# Search and filter

## Requirement: Category filter
Scenario: filter
- Given 10,000 cached movies across categories
- When a category is selected
- Then only that category's items are returned without reloading data

## Requirement: Instant search
Scenario: accent and case insensitive
- Given an item named "Película Épica"
- When searching "pelicula epica"
- Then the item is returned

Scenario: combined
- Given a selected category and a text query
- When both are applied
- Then results satisfy both

Scenario: performance
- Given 10,000 items
- When searching
- Then the result is computed in under 50 ms
