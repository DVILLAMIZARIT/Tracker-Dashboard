Feature: Admins have a page of admin-only functionality

  Scenario: Users cannot go to admin page
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    Then I should not see "Admin"

  Scenario: Admin can go to admin index page
    Given Tracker has a user "user" with password "pass"
    And user "user" is an admin
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Admin"
    Then I should be on the admin page

  Scenario: Admin can go to admin page with users
    Given Tracker has a user "user" with password "pass"
    And user "user" is an admin
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Admin"
    And I follow "Users"
    Then I should be on the admin listing of users

  Scenario: Admin can go to admin page with projects
    Given Tracker has a user "user" with password "pass"
    And user "user" is an admin
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Admin"
    And I follow "Projects"
    Then I should be on the admin listing of projects
