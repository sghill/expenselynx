Feature: Set default participants display visibility
  In order to have a manageable touch interface for participants
  As a user
  I want to customize which participants are displayed in the receipt form

  Scenario: Adding a new participant to the system
    Given I am logged in as "chuck@example.com"
    And "chuck@example.com" has created a receipt with participant "rafael"
    When I am on the dashboard page
    Then I should see "rafael" in the receipt form