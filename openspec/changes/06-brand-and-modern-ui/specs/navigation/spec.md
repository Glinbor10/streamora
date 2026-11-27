# Navigation

## Requirement: Floating pill bar on phones
Scenario: narrow window
- Given a window narrower than 600 px
- Then a floating rounded bar with Live TV, Movies and Series is shown over the content with a cyan indicator on the selected item

## Requirement: Icon rail on desktop
Scenario: wide window
- Given a window of 600 px or wider
- Then a slim icon rail with tooltips is shown instead

Scenario: no overflow
- Given widths 360, 600 and 1280 px
- Then the shell lays out without errors
