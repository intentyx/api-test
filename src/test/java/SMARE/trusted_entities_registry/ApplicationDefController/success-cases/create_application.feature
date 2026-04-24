Feature: Create Application Definition

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * configure headers = { Authorization: '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'

  Scenario: Create a new application definition
    And path 'applications'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Test Application2",
        "description": "Created for Karate Testing2",
        "ownerEmail": "app@gmail.com"
      }
      """
    When method post
    Then status 201
    And match response.id == '#uuid'
    And match response.name == 'Test Application2'
    And match responseHeaders['Location'][0] contains 'applications/'
    * def createdAppId = response.id
    * print 'Created Application ID:', createdAppId
