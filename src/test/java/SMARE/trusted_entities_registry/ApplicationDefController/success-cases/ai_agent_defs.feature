Feature: AI Agent Definitions CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }


    * url 'http://localhost:8080/smare'
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: CRUD operations for AI Agent Definition
    Given path 'applications', appId, 'aiAgentDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appGuid": "#(appId)",
        "name": "Test AI Agent",
        "description": "Agent created by Karate",
        "agentType": "planner",
        "trustStatus": "UNKNOWN",
        "riskLevel": "LOW"
      }
      """
    When method post
    Then status 200
    * print "Response:", response


    Given path 'applications', appId, 'aiAgentDefs'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
    * def agentDefId = response[0].id

    Given path 'applications', appId, 'aiAgentDefs', agentDefId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == agentDefId


    Given path 'applications', appId, 'aiAgentDefs', agentDefId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(agentDefId)",
        "appGuid": "#(appId)",
        "name": "Updated AI Agent",
        "description": "Updated Agent description",
        "agentType": "planner",
        "trustStatus": "UNKNOWN",
        "riskLevel": "LOW"
      }
      """
    When method put
    Then status 204

    Given path 'applications', appId, 'aiAgentDefs', agentDefId
    When method delete
    Then status 204
