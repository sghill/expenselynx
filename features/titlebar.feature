Feature: Titlebar
  In order to easily access account settings
  As a user
  I want to see links for signing out and account management

  Scenario: sign out
    Given I am logged in as "chuck@example.com"
    When I follow "sign out"
    Then I should see the login page