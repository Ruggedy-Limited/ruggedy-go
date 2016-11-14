Feature: As a user of the API framework and the owner of at least one team
  I want the ability to manage users through the API
  So that I can create, edit and delete user accounts inside my account instance
  So that I can report on the state of users through the API
  (last login, account state - active / inactive, use of 2FA (Yes / No)

  As an administrator and user of the API framework
  I want the ability to enter personally identifiable data
  So that:
  * My email address is available for notifications
  * My password is changeable
  * My personal data such as mobile numbers and addresses are changeable.

  Background:
    Given the following existing Users:
      | id | name        | email                      | password                                                     | remember_token | photo_url    | uses_two_factor_auth | authy_id | country_code | phone       | two_factor_reset_code | current_team_id | stripe_id | current_billing_plan | card_brand | card_last_four | card_country | billing_address | billing_address_line_2 | billing_city | billing_state | billing_zip | billing_country | vat_id | extra_billing_information | trial_ends_at       | last_read_announcements_at | created_at          | updated_at          |
      | 1  | John Smith  | johnsmith@dispostable.com  | $2y$10$IPgIlPVo/NW6fQMx0gJUyesYjV1N4LwC1fH2rj94s0gq.xDjMisNm | NULL           | NULL         | 0                    | NULL     | ZAR          | 0716852996  | NULL                  | 1               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-19 14:39:01 | 2016-05-09 14:39:01        | 2016-05-09 14:39:01 | 2016-05-09 14:39:02 |
      | 2  | Greg Symons | gregsymons@dispostable.com | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /myphoto.jpg | 0                    | NULL     | NZ           | 06134582354 | NULL                  | 1               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-20 11:51:29 | 2016-05-10 11:51:43        | 2016-05-10 11:51:29 | 2016-05-10 11:51:43 |
      | 3  | Jack White  | jackwhite@dispostable.com  | $2y$10$0WLCM1EUuJce.zSlS1N4h.XRn7u8uDbyxslTkFOI0ka0fxSIXmjhC | NULL           | /jack.jpg    | 1                    | NULL     | NZ           | 06334787357 | NULL                  | 2               | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-21 12:51:29 | 2016-05-11 12:51:43        | 2016-05-11 12:51:29 | 2016-05-11 12:51:43 |
    And the following existing Teams:
      | id | owner_id | name        | photo_url | stripe_id | current_billing_plan | card_brand | card_last_four | card_country | billing_address | billing_address_line_2 | billing_city | billing_state | billing_zip | billing_country | vat_id | extra_billing_information | trial_ends_at       | created_at          | updated_at          |
      | 1  | 1        | John's Team | NULL      | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-09 14:39:01 | 2016-05-09 14:39:01 | 2016-05-09 14:39:01 |
      | 2  | 3        | Jack's Team | NULL      | NULL      | NULL                 | NULL       | NULL           | NULL         | NULL            | NULL                   | NULL         | NULL          | NULL        | NULL            | NULL   | NULL                      | 2016-05-11 11:39:01 | 2016-05-11 11:39:01 | 2016-05-09 14:39:01 |
    And the following Users in Team 1:
      | id | role   |
      | 1  | owner  |
      | 2  | member |
    And the following existing Components:
      | id | name            | class_name | created_at          | updated_at          |
      | 1  | User Account    | User       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 2  | Team            | Team       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 3  | Project         | Project    | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 4  | Workspace       | Workspace  | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 5  | Asset           | Asset      | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 6  | Scanner App     | ScannerApp | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 7  | Event           | Event      | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
      | 8  | Rules           | Rule       | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    And the following existing ComponentPermissions:
      | id | component_id | instance_id | permission | user_id | team_id | granted_by | created_at          | updated_at          |
      | 1  | 1            | 2           | rw         | 1       | NULL    | 2          | 2016-05-10 00:00:00 | 2016-05-10 00:00:00 |
    And a valid API key "OaLLlZl4XB9wgmSGg7uai1nvtTiDsLpSBCfFoLKv18GCDdiIxxPLslKZmcPN"

  Scenario: Adding a person to one of the teams on my account
    Given that I want to add a "Person" to my team
    And that their "email" is "garethpeter@gmail.com"
    When I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "garethpeter@gmail.com"
    And the response has a "token" property
    And the type of the "token" property is string

  Scenario: I attempt to add a person to one of the teams on my account, but I provide an invalid team ID
    Given that I want to add a "Person" to my team
    And that their "email" is "garethpeter@gmail.com"
    When I request "/api/user/10"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that team does not exist."

  Scenario: I attempt to add a person to one of the teams on my account, but I don't provide a valid email address
    Given that I want to add a "Person" to my team
    And that their "email" is "garethpetergmail.com"
    When I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, the email address you provided is invalid."

  Scenario: Removing a person from one of the teams on my account
    Given that I want to remove a "Person" from my team
    When I request "/api/user/1/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "user.emailAddress" property
    And the type of the "user.emailAddress" property is string
    And the "user.emailAddress" property equals "gregsymons@dispostable.com"
    And the response has a "team.id" property
    And the type of the "team.id" property is integer
    And the "team.id" property equals "1"

  Scenario: I attempt to remove a person from one of the teams on my account, but I provide an invalid team ID
    Given that I want to remove a "Person" from my team
    And that their "email" is "gregsymons@dispostable.com"
    When I request "/api/user/11/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that team does not exist."

  Scenario: I attempt to remove a person from one of the teams on my account, but I provide User ID that doesn't exist in that team
  doesn't exist in that team
    Given that I want to remove a "Person" from my team
    When I request "/api/user/1/3"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that person is not part of that team."

  Scenario: Get all possible information regarding a team member
    Given that I want to get information about a "Person" on one of my teams
    When I request "/api/user/1/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "Greg Symons"
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "gregsymons@dispostable.com"
    And the response has a "photo" property
    And the type of the "photo" property is string
    And the "photo" property equals "/myphoto.jpg"
    And the response has a "twoFactorAuthEnabled" property
    And the type of the "twoFactorAuthEnabled" property is int
    And the "twoFactorAuthEnabled" property equals "0"

  Scenario: I attempt to get information about a person on one of my teams, but there is no person with the given ID in
    that team
    Given that I want to get information about a "Person" on one of my teams
    When I request "/api/user/1/3"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that person is not part of that team."

  Scenario: I attempt to get information about a person on one of my teams, but I provide an invalid team ID
    Given that I want to get information about a "Person" on one of my teams
    When I request "/api/user/11/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, that team does not exist."

  Scenario: Get a list of users in one of my teams
    Given that I want to get information about a "People" on one of my teams
    When I request "/api/users/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the type of the response is array
    And the array response has the following items:
    | name        | emailAddress               | photo        | twoFactorAuthEnabled |
    | John Smith  | johnsmith@dispostable.com  | *            | false                |
    | Greg Symons | gregsymons@dispostable.com | /myphoto.jpg | false                |


  Scenario: I attempt to get a list of users for a team that I don't own
    Given that I want to get information about a "People" on one of my teams
    When I request "/api/users/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't own that team."

  Scenario: Changing my email address
    Given that I want to update my "Account"
    And that I want to change my "email" to "garethpeter@gmail.com"
    When I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "John Smith"
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "garethpeter@gmail.com"
    And the response has a "twoFactorAuthEnabled" property
    And the type of the "twoFactorAuthEnabled" property is int
    And the "twoFactorAuthEnabled" property equals "0"
    And the response has a "createdDate" property
    And the type of the "createdDate" property is string
    And the "createdDate" property equals "2016-05-09 14:39:01"
    And the response has a "modifiedDate" property
    And the type of the "modifiedDate" property is string
    And the "modifiedDate" property does not equal "2016-05-09 14:39:02"
    
  Scenario: Changing my password
    Given that I want to update my "Account"
    And that I want to change my "password" to "Pa$$w0rd"
    When I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "John Smith"
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "johnsmith@dispostable.com"
    And the response has a "twoFactorAuthEnabled" property
    And the type of the "twoFactorAuthEnabled" property is integer
    And the "twoFactorAuthEnabled" property equals "0"
    And the response has a "createdDate" property
    And the type of the "createdDate" property is string
    And the "createdDate" property equals "2016-05-09 14:39:01"
    And the response has a "modifiedDate" property
    And the type of the "modifiedDate" property is string
    And the "modifiedDate" property does not equal "2016-05-09 14:39:02"

  Scenario: Changing multiple fields
    Given that I want to update my "Account"
    And that I want to change my "email" to "garethpeter@gmail.com"
    And that I want to change my "password" to "Pa$$w0rd"
    And that I want to change my "photo_url" to "/my/photo/url.jpg"
    And that I want to change my "uses_two_factor_auth" to "1"
    When I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "John Smith"
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "garethpeter@gmail.com"
    And the response has a "photo" property
    And the type of the "photo" property is string
    And the "photo" property equals "/my/photo/url.jpg"
    And the response has a "twoFactorAuthEnabled" property
    And the type of the "twoFactorAuthEnabled" property is integer
    And the "twoFactorAuthEnabled" property equals "1"
    And the response has a "createdDate" property
    And the type of the "createdDate" property is string
    And the "createdDate" property equals "2016-05-09 14:39:01"
    And the response has a "modifiedDate" property
    And the type of the "modifiedDate" property is string
    And the "modifiedDate" property does not equal "2016-05-09 14:39:02"

  Scenario: I attempt to modify another person's account
    Given that I want to update my "Account"
    And that I want to change my "password" to "Pa$$w0rd"
    And I request "/api/user/2"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response has a "error" property
    And the type of the "error" property is boolean
    And the "error" property equals "true"
    And the response has a "message" property
    And the type of the "message" property is string
    And the "message" property equals "Sorry, you don't have permission to edit that account."

  Scenario: I attempt to modify a non-existant field on my account
    Given that I want to update my "Account"
    And that I want to change my "non_field" to "Does not exist"
    And I request "/api/user/1"
    Then the HTTP response code should be 200
    And the response is JSON
    And the response does not have a "error" property
    And the response has a "name" property
    And the type of the "name" property is string
    And the "name" property equals "John Smith"
    And the response has a "emailAddress" property
    And the type of the "emailAddress" property is string
    And the "emailAddress" property equals "johnsmith@dispostable.com"
    And the response has a "twoFactorAuthEnabled" property
    And the type of the "twoFactorAuthEnabled" property is int
    And the "twoFactorAuthEnabled" property equals "0"
    And the response has a "createdDate" property
    And the type of the "createdDate" property is string
    And the "createdDate" property equals "2016-05-09 14:39:01"
    And the response has a "modifiedDate" property
    And the type of the "modifiedDate" property is string
    And the "modifiedDate" property does not equal "2016-05-09 14:39:02"