Feature: Export expense report data validation
  In order to download my expense report as a CSV
  And enter it into my company's expense reporting system through a macro
  As a user
  I want to see that my data is valid for a complete export
  
  Scenario: User has a receipt from a store that is missing an expense category
    Given I am logged in as "chuck@example.com"
    And I have an unexpensed receipt from a new store
    When I am on the unexpensed receipts page
    Then I should see "Export Ready?"
    Then I should see "—" in the "exportable" column