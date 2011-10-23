Feature: User sees a listing of their projects

  Background:
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"

  Scenario: User logs in and sees their projects
    Then I should be on the projects page 
    And I should see "Pivotal Tracker API Gem"

  @javascript
  Scenario: User sees any red flags
    And I wait until all Ajax requests are complete
    Then I should see "1 unestimated story"
    And I should see "2 blocked stories"

  @javascript
  Scenario: User sees a prompt to set up goals
    And I wait until all Ajax requests are complete
    Then I should see "You haven't set up any goals"

  @javascript
  Scenario: User sees progress toward goal completion
    And I wait until all Ajax requests are complete
    And I follow "set up"
    And I check "project_settings[tracks_attributes][1][enabled]"
    And I fill in "project_settings[tracks_attributes][1][goal_stories]" with "5"
    And I check "project_settings[tracks_attributes][2][enabled]"
    And I fill in "project_settings[tracks_attributes][2][goal_points]" with "1"
    And I press "Update"
    And I go to the projects page
    And I wait until all Ajax requests are complete
    Then I should see "label 1: 1 of 5 stories done"
    And I should see "label 2: 0 of 1 point done"

