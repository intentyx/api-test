Feature: Delete Application Definition

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * url 'http://localhost:8080/smare'
    * configure headers = { Authorization: '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }

  Scenario: Create and then delete an application definition

    Given path 'applications'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "App To Delete",
        "description": "Application created for delete feature testing",
        "ownerEmail": "delete@test.com"
      }
      """
    When method post
    Then status 201
    * def appId = response.id

    Given path 'applications', appId
    When method get
    Then status 200
    * print "Response:", response

    Given path 'applications', appId
    When method delete
    Then status 204

    Given path 'applications', appId
    When method get
    Then status 404
