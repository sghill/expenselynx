Feature: Users
  In order to maintain expenses
  A user should be able to
  Register
  Login

  Scenario: Register as a new user
    When I go to the registration page
    Then I should not see a "sign out" link
    Then I should not see a "Unexpensed Receipts" link
    Then I should not see a "notice" element
    Then I should not see a "alert" element
    And I enter my email address as "chuck@example.com"
    And I enter my password as "falaFEL7"
    And I enter my password confirmation as "falaFEL7"
    And I press "sign up"
    Then I should see my dashboard

  Scenario: Login as an existing user
    Given that a user with email address "chuck@example.com" and password "test!234" exists
    When I go to the login page
    Then I should not see a "sign out" link
    Then I should not see a "Unexpensed Receipts" link
    And I enter my email address as "chuck@example.com"
    And I enter my password as "test!234"
    And I press "sign in"
    Then I should see my dashboard
