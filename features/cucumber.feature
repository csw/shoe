Feature: Cucumber
  In order to use cucumber conveniently
  As a developer
  I want shoe to give me a rake task

  Scenario: Running rake --tasks in a shoe project without Cucumber features
    Given I have created a directory called "my_project"
    And I have run shoe inside "my_project"
    When I run rake --tasks inside "my_project"
    Then I should not see "rake cucumber" on standard out

  Scenario: Running rake --tasks in a shoe project with Cucumber features
    Given I have created a directory called "my_project"
    Given I have created a directory called "my_project/features"
    And I have run shoe inside "my_project"
    When I run rake --tasks inside "my_project"
    Then I should see "rake cucumber" on standard out
