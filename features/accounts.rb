Feature: User logs in/out
  Scenario: User logs in
    Given I am not logged in
    When I go to the home page
    Then I should be on the login page
    And I should see "Login"
