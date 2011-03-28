Feature: Update Participants
  In order to manage participants' metadata individually
  As a user
  I want to update an individual participant
  
  Scenario: Change the name of a participant
    Given I am logged in as "chuck@example.com"
    And "chuck@example.com" has created a receipt with participant "tom"
    When I am on the edit participant page for "tom"
    And I fill in "participant_name" with "clancy"
    And press "Update Participant"
    Then I should see "clancy"