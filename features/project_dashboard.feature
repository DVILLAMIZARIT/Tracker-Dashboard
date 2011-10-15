Feature: User sees a dashboard for a project

  Background:
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Pivotal Tracker API Gem"

  Scenario: User sees the current iteration's stats in the 'All' track
    Then I should see "17" stories and "9" points with "Done" status in the "All" track
    And I should see "17" stories and "9" points with "WIP" status in the "All" track
    And I should see "17" stories and "9" points with "Scheduled" status in the "All" track

  Scenario: User configures tracks
    And I follow "edit"
    And I check the first "enabled" box
    And I fill in "12" for the first budget box
    And I press "Update"
    Then I should see "3" tracks

  Scenario: User sees a link to snapshots
    And I follow "snapshots"
    Then I should see "Pivotal Tracker API Gem » Snapshots"

  Scenario: User sees individual stories

