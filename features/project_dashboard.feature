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

  Scenario: User sees all labels when configuring tracks
    And I follow "edit"
    Then I should see a text input with value "label 1"
    Then I should see a text input with value "label 2"
    Then I should see a text input with value "label 3"
    Then I should see a text input with value "label 4"
    Then I should see a text input with value "label 5"

  Scenario: User configures tracks
    And I follow "edit"
    And I check "project_settings[tracks_attributes][0][enabled]"
    And I fill in "project_settings[tracks_attributes][0][goal_stories]" with "12"
    And I press "Update"
    And I should see a track named "label 1"

  Scenario: User sees a link to snapshots
    And I follow "Snapshots"
    Then I should see "Pivotal Tracker API Gem"
    And I should see "Snapshots"

  Scenario: User sees individual stories

