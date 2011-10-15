Feature: User sees a dashboard for a project

  Background:
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Pivotal Tracker API Gem"

  Scenario: User sees the current iteration's stats in the 'All' and 'Other' tracks
    Then I should see "1" stories and "2" points with "done" status in the "All" track
    And I should see "2" stories and "4" points with "wip" status in the "All" track
    And I should see "5" stories and "7" points with "scheduled" status in the "All" track
    And I should see "0" stories and "0" points with "blocked" status in the "All" track
    And I should see "0" stories and "0" points with "unestimated" status in the "All" track
    And I should see "1" stories and "2" points with "done" status in the "Other" track
    And I should see "2" stories and "4" points with "wip" status in the "Other" track
    And I should see "5" stories and "7" points with "scheduled" status in the "Other" track
    And I should see "0" stories and "0" points with "blocked" status in the "Other" track
    And I should see "0" stories and "0" points with "unestimated" status in the "Other" track

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

