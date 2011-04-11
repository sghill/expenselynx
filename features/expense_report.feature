Feature: View expense report
  In order to see the receipts included in an expense report
  As a user
  I want to view the receipts table
  
  Scenario: View receipts in the expense report
    Given I am logged in as "chuck@example.com"
    And I have an expense report in the system
    When I am on the expense report page
    Then I should see "download as csv"