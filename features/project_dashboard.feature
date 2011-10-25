Feature: User sees a dashboard for a project

  Background:
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Pivotal Tracker API Gem"

  Scenario: User sees the current iteration's stats 
    Then I should see "1" stories and "2" points with "done" status in the "All" track
    And I should see "2" stories and "4" points with "wip" status in the "All" track
    And I should see "7" stories and "9" points with "scheduled" status in the "All" track
    And I should see "2" stories and "2" points with "blocked" status in the "All" track
    And I should see "1" stories and "0" points with "unestimated" status in the "All" track

  Scenario: User sees tracks for All and Other, as well as some random, initial tracks (to show how they work).
    Then I should see a track named "All"
    And I should see a track named "label 2"
    And I should see a track named "label 4"
    And I should see a track named "label 1"
    And I should see a track named "Other"

  Scenario: User sees all labels when configuring tracks
    #And I edit the goals
    And I follow "edit" within "#edit-goals"
    Then I should see a text input with value "label 1"
    Then I should see a text input with value "label 2"
    Then I should see a text input with value "label 3"
    Then I should see a text input with value "label 4"
    Then I should see a text input with value "label 5"

  Scenario: User configures tracks
    And I follow "edit" within "#edit-goals"
    And I check "project_settings[tracks_attributes][0][enabled]"
    And I fill in "project_settings[tracks_attributes][0][goal_stories]" with "12"
    And I press "Update"
    And I should see a track named "label 1"

  Scenario: Projects have default red flags labels
    And I follow "edit labels"
    Then "blocked" should be selected for "project_settings[red_flags_blocked_label]"
    And "added_midweek" should be selected for "project_settings[red_flags_unplanned_label]"
    And "ship_this_week" should be selected for "project_settings[red_flags_unmet_label]"

  Scenario: User configures red flag labels
    And I follow "edit labels"
    And I select "label 1" from "project_settings[red_flags_blocked_label]"
    And I select "label 2" from "project_settings[red_flags_unplanned_label]"
    And I select "label 3" from "project_settings[red_flags_unmet_label]"
    And I press "Update"
    Then I should see "3" stories and "4" points with "blocked" status in the "All" track
    And I should see "3" stories and "6" points with "unplanned" status in the "All" track
    And I should see "1" stories and "2" points with "unmet_reqs" status in the "All" track

  @javascript
  Scenario: User configures red flag labels, chosing new labels that aren't in any stories
    And I follow "edit labels"
    And I select or add "label 123456" from "project_settings[red_flags_blocked_label]"
    And I press "Update"
    And I follow "edit labels"
    Then "label 123456" should be selected for "project_settings[red_flags_blocked_label]"

  Scenario: User sees a link to snapshots
    And I follow "Snapshots"
    Then I should see "Pivotal Tracker API Gem"
    And I should see "Snapshots"

  Scenario: User sees individual stories

