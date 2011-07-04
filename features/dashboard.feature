@javascript
Feature: As a user I want to see a dashboard of my expenses

  Scenario: A user has no current expenses
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    Then I should have "$0.00" in unexpensed spendings
