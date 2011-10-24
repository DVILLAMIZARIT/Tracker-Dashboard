Feature: User logs in and out

  Scenario: User logs in with correct credentials
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    Then I should be on the projects page 

  Scenario: User logs in with wrong credentials
    Given Tracker has no user "wronguser" with password "wrongpass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "wronguser"
    And I fill in "session_password" with "wrongpass"
    And I press "Sign in"
    Then I should be on the login page
    And I should see "Invalid"

  Scenario: User logs out
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the login page
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Sign Out"
    Then I should be on the login page

  Scenario: Un-logged-in user is redirected to login then redirected back to his desired URL
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the "Pivotal Tracker API Gem" project page 
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    Then I should be on the "Pivotal Tracker API Gem" project page

  Scenario: Return to the Tracker Dashboard project page I had been on
    Given Tracker has a user "user" with password "pass"
    And Tracker has a project "Pivotal Tracker API Gem"
    When I go to the homepage
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    And I follow "Pivotal Tracker API Gem"
    And I follow "Sign Out"
    And I close the browser
    And I open the browser
    And I go to the homepage
    And I fill in "session_username" with "user"
    And I fill in "session_password" with "pass"
    And I press "Sign in"
    Then I should be on the "Pivotal Tracker API Gem" project page

  Scenario: Return to the Tracker Dashboard project page I had been on even if I was on a dumb admin page
     Given Tracker has a user "user" with password "pass"
     And Tracker has a project "Pivotal Tracker API Gem"
     When I go to the homepage
     And I fill in "session_username" with "user"
     And I fill in "session_password" with "pass"
     And I press "Sign in"
     And I follow "Pivotal Tracker API Gem"
     And I follow "edit"
     And I follow "Sign Out"
     And I close the browser
     And I open the browser
     And I go to the homepage
     And I fill in "session_username" with "user"
     And I fill in "session_password" with "pass"
     And I press "Sign in"
     Then I should be on the "Pivotal Tracker API Gem" project page




