Feature: View and edit the participants of receipts
  In order to view aggregate information of receipt participants
  As a user
  I want to easily view all participants
  And edit individual participants
  
  Scenario: List of participants
    Given I am logged in as "chuck@example.com"
    And I have created a new receipt with "JC, Sonia" as participants
    When I go to the participants page
    Then I should see "JC"
    And I should see "Sonia"
    And I should see "edit"