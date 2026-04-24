Feature: Update Application Definition

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * configure headers = { 'Authorization': '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'

  Scenario: Create and then update an application definition
    And path 'applications'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "App To Update",
        "description": "Will be updated",
        "ownerEmail": "update@test.com"
      }
      """
    When method post
    Then status 201
    * def appId = response.id

    Given url 'http://localhost:8080/smare'
    And path 'applications', appId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(appId)",
        "name": "Updated Application Name",
        "description": "Updated for karate testing",
        "ownerEmail": "update@test.com"
      }
      """
    When method put
    Then status 200
    * print "Response:", response
