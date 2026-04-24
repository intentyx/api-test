Feature: Agent API Endpoints CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'

    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

    Given path 'applications', appId, 'aiAgentDefs'
    And header Content-Type = 'application/json'
    And request { appGuid: '#(appId)', name: 'Agent For Endpoints', description: 'Parent agent', "agentType": "planner", "trustStatus": "UNKNOWN", "riskLevel": "LOW" }
    When method post
    Then status 200
    * print "Response:", response

    Given path 'applications', appId, 'aiAgentDefs'
    When method get
    Then status 200
    * print "Response:", response
    * def agentDefId = response[0].id

  Scenario: CRUD for Agent API Endpoint
    Given path 'applications', appId, 'aiAgentDefs', agentDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(agentDefId)",
        "parentType": "AGENT",
        "name": "GET /agent-health",
        "path": "/agent-health",
        "httpMethod": "GET",
        "protocolType": "REST",
        "trustStatus": "UNKNOWN",
        "handlesPii": false,
        "handlesSensitive": false
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    Given path 'applications', appId, 'aiAgentDefs', agentDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
    * def endpointId = response[0].id

    Given path 'applications', appId, 'aiAgentDefs', agentDefId, 'apiEndpoints', endpointId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == endpointId

    Given path 'applications', appId, 'aiAgentDefs', agentDefId, 'apiEndpoints', endpointId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(endpointId)",
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(agentDefId)",
        "parentType": "AGENT",
        "name": "GET /agent-health-updated",
        "path": "/agent-health",
        "httpMethod": "GET",
        "protocolType": "REST",
        "trustStatus": "UNKNOWN",
        "handlesPii": false,
        "handlesSensitive": false
      }
      """
    When method put
    Then status 204

    Given path 'applications', appId, 'aiAgentDefs', agentDefId, 'apiEndpoints', endpointId
    When method delete
    Then status 204
