Feature: Users
  In order to maintain expenses
  A user should be able to
  Register
  Login

  Scenario: Register as a new user
    Given that a user with email address "chuck@example.com" has not registered
    When I go to the registration page
    Then I should not see a "Sign Out" link
    Then I should not see a "Unexpensed Receipts" link
    Then I should not see a "notice" element
    Then I should not see a "alert" element
    And enter my email address as "chuck@example.com"
    And enter my password as "falaFEL7"
    And enter my password confirmation as "falaFEL7"
    And I press "sign up"
    Then I should see my dashboard

  Scenario: Login as an existing user
    Given that a user with email address "chuck@example.com" and password "test!234" exists
    When I go to the login page
    Then I should not see a "Sign Out" link
    Then I should not see a "Unexpensed Receipts" link
    And enter my email address as "chuck@example.com"
    And enter my password as "test!234"
    And I press "sign in"
    Then I should see my dashboard
