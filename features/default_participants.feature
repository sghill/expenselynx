Feature: Display only default participants
  In order to have a manageable and meaningful list of participants on receipt form
  As a user
  I want to be able to turn off participants from displaying
  
  Scenario: Add new participant
    Given I am logged in as "chuck@example.com"
    And I have created a new receipt with "Alec Berg" as a participant
    When I go to the dashboard page
    Then I should see the participant "Alec Berg"
    
  Scenario: Setting a participant to not display
    Given I am logged in as "chuck@example.com"
    And I have created a new receipt with "Tom" as a participant
    When I go to the edit participant "Tom" page
    And I uncheck "Display on Receipt Form"
    And press "Update Participant"
    When I go to the dashboard page
    Then I should not see the participant "Tom"