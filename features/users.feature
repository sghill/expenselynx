Feature: Users
In order to maintain expenses
A user should be able to
Register
Login

Scenario: Register
Given that a user with email address "chuck@example.com" has not registered
When I go to the registration page
And enter my email address as "chuck@example.com"
And enter my password as "falaFEL7"
And enter my password confirmation as "falaFEL7"
And click the "Sign up" button
Then I should see my dashboard

Scenario: Login
Given that a user with email address "chuck@example.com" and password "test!234" exists
When I go to the login page
And enter my email address as "chuck@example.com"
And enter my password as "test!234"
And click the "Sign in" button
Then I should see my dashboard