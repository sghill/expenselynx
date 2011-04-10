@javascript
Feature: As a user I want to see a dashboard of my expenses

  Scenario: A user has no current expenses
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    Then I should have "$0.00" in unexpensed spendings

  Scenario: A user an unexpensable receipt
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    And I enter the following receipts:
      | Date       | Store           | Total | Expensable? | Expensed? |
      | 2010-01-19 | Banana Republic | 5.00  | —           | —         |
    Then I should have "$0.00" in unexpensed spendings

  Scenario: A user has an unexpensed expensable receipt
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    And I enter the following receipts:
      | Date       | Store           | Total | Expensable? | Expensed? |
      | 2010-01-19 | Banana Republic | 5.00  | ✓           | —         |
    Then I should have "$5.00" in unexpensed spendings

  Scenario: A user has an expensed expensable receipt
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    And I enter the following receipts:
      | Date       | Store           | Total | Expensable? | Expensed? |
      | 2010-01-19 | Banana Republic | 5.00  | ✓           | ✓         |
    Then I should have "$0.00" in unexpensed spendings

  Scenario: A user has entered 7 receipts and refresh the page
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    And I enter the following receipts:
      | Date       | Store           | Total | Expensable? | Expensed? |
      | 2010-01-19 | Banana Republic | 1.00  | ✓           | ✓         |
      | 2010-01-19 | Coles           | 5.00  | ✓           | ✓         |
      | 2010-01-19 | Jag             | 4.00  | ✓           | —         |
      | 2010-01-19 | North West      | 3.00  | ✓           | ✓         |
      | 2010-01-19 | Saba            | 10.00 | ✓           | ✓         |
      | 2010-01-19 | Woolworths      | 1.00  | ✓           | ✓         |
      | 2010-01-19 | Boost           | 0.50  | ✓           | ✓         |
    Then I should have "$4.00" in unexpensed spendings
    And I am on the dashboard page
    And I should see the following recent receipts:
      | Purchase Date   | Store      | Total  | Expensable? | Expensed? |
      | 2010-01-19      | Boost      | $0.50  | ✓           | ✓         |
      | 2010-01-19      | Woolworths | $1.00  | ✓           | ✓         |
      | 2010-01-19      | Saba       | $10.00 | ✓           | ✓         |
      | 2010-01-19      | North West | $3.00  | ✓           | ✓         |
      | 2010-01-19      | Jag        | $4.00  | ✓           | —         |

  @flakey
  Scenario: A user has entered 7 receipts and don't refresh the page
    Given I am logged in as "chuck@example.com"
    When I am on the dashboard page
    And I enter the following receipts:
      | Date       | Store           | Total | Expensable? | Expensed? |
      | 2010-01-19 | Banana Republic | 1.00  | ✓           | ✓         |
      | 2010-01-19 | Coles           | 5.00  | ✓           | ✓         |
      | 2010-01-19 | Jag             | 4.00  | ✓           | —         |
      | 2010-01-19 | North West      | 3.00  | ✓           | ✓         |
      | 2010-01-19 | Saba            | 10.00 | ✓           | ✓         |
      | 2010-01-19 | Woolworths      | 1.00  | ✓           | ✓         |
      | 2010-01-19 | Boost           | 0.50  | ✓           | ✓         |
    Then I should have "$4.00" in unexpensed spendings
    And I should see the following recent receipts:
      | Purchase Date   | Store      | Total  | Expensable? | Expensed? |
      | 2010-01-19      | Boost      | $0.50  | ✓           | ✓         |
      | 2010-01-19      | Woolworths | $1.00  | ✓           | ✓         |
      | 2010-01-19      | Saba       | $10.00 | ✓           | ✓         |
      | 2010-01-19      | North West | $3.00  | ✓           | ✓         |
      | 2010-01-19      | Jag        | $4.00  | ✓           | —         |
