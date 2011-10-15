Feature: User sees a listing of their projects

  Scenario: User logs in and sees their projects
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    Then I should be on the projects page 
    And I should see "Pivotal Tracker API Gem"
