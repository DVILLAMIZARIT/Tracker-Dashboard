Feature: User sees a dashboard for a project

  Background:
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Pivotal Tracker API Gem"
    And I follow "Snapshots"

  Scenario: User create snapshots
    And I follow "Create new snapshot"
    Then I should see "1" snapshots


