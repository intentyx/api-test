Feature: Get Application Definition

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    # 1. Create Application
    Given path 'applications'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Test App",
        "description": "App to test retrieval",
        "ownerEmail": "test@example.com"
      }
      """
    When method post
    Then status 201
    * def appId = response.id

  Scenario: Get an existing application by ID
    Given path 'applications', appId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == appId

  Scenario: Get an existing application with fetch parameter
    Given path 'applications', appId
    And param fetch = 'all'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == appId

  Scenario: Get non-existent application returns 404
    * def fakeAppId = '00000000-0000-0000-0000-000000000000'
    Given path 'applications', fakeAppId
    And header Content-Type = 'application/json'
    When method get
    Then status 404
