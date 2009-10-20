Feature: Release
  In order to conveniently make a release of my project
  As a developer
  I want shoe to give me a rake task

  Background:
    Given I have created a directory called "origin"
    And I have run git init inside "origin"
    Given I have created a directory called "my_project"
    And I have run shoe inside "my_project"
    And I have run git init inside "my_project"
    And I have run git add . inside "my_project"
    And I have run git commit -m "Initial commit" inside "my_project"
    And I have run git remote add origin ../origin inside "my_project"

  Scenario: I can release
    When I run git push origin master inside "my_project"
    And I replace "0.0.0" with "0.1.0" in the file "my_project/Rakefile"
    And I run rake --tasks inside "my_project"
    Then I should see "rake release" on standard out

  Scenario: I cannot release when the version is 0.0.0
    When I run git push origin master inside "my_project"
    And I run rake --tasks inside "my_project"
    Then I should not see "rake release" on standard out

  Scenario: I cannot release when I already have a tag for the current version
    When I run git push origin master inside "my_project"
    And I run git tag 0.1.0 inside "my_project"
    And I replace "0.0.0" with "0.1.0" in the file "my_project/Rakefile"
    And I run rake --tasks inside "my_project"
    Then I should not see "rake release" on standard out

  Scenario: I cannot release when I have not yet pushed master to origin
    When I replace "0.0.0" with "0.1.0" in the file "my_project/Rakefile"
    And I run rake --tasks inside "my_project"
    Then I should not see "rake release" on standard out

  Scenario: I cannot release from a branch other than master
    When I run git push origin master inside "my_project"
    And I run git checkout -b topic inside "my_project"
    And I replace "0.0.0" with "0.1.0" in the file "my_project/Rakefile"
    And I run rake --tasks inside "my_project"
    Then I should not see "rake release" on standard out