Feature: API Endpoints for Service Definitions

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    # Create an application
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId
    # Create a service def under it
    Given path 'applications', appId, 'serviceDefs'
    And header Content-Type = 'application/json'
    And request { appGuid: '#(appId)', name: 'Service For Endpoints', description: 'Parent service', trustStatus: 'UNKNOWN', version: '1.0' }
    When method post
    Then status 200
    * print "Response:", response
    # Fetch the service def ID
    Given path 'applications', appId, 'serviceDefs'
    When method get
    Then status 200
    * print "Response:", response
    * def serviceDefId = response[0].id

  Scenario: Create an API endpoint under a service definition
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "SERVICE",
        "name": "GET /health",
        "path": "/health",
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

  Scenario: Get all API endpoints for a service definition
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'

  Scenario: Create and then get an API endpoint by ID
    # Step 1: Create
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "SERVICE",
        "name": "GET /status",
        "path": "/status",
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

    # Step 2: Get all to find the ID
    Given path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    When method get
    Then status 200
    * print "Response:", response
    * def endpointId = response[0].id

    # Step 3: Get by ID
    Given path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints', endpointId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == endpointId

  Scenario: Create and then update an API endpoint
    # Step 1: Create
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "SERVICE",
        "name": "POST /data",
        "path": "/data",
        "httpMethod": "POST",
        "protocolType": "REST",
        "trustStatus": "UNKNOWN",
        "handlesPii": false,
        "handlesSensitive": false
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    # Step 2: Get all to find the ID
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    When method get
    Then status 200
    * print "Response:", response
    * def endpointId = response[0].id

    # Step 3: Update
    Given path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints', endpointId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(endpointId)",
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "SERVICE",
        "name": "POST /data-updated",
        "path": "/data-updated",
        "httpMethod": "POST",
        "protocolType": "REST",
        "trustStatus": "UNKNOWN",
        "handlesPii": false,
        "handlesSensitive": false
      }
      """
    # When method put
    # Then status 204

  Scenario: Create and then delete an API endpoint
    # Step 1: Create
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "SERVICE",
        "name": "DELETE /temp",
        "path": "/temp",
        "httpMethod": "DELETE",
        "protocolType": "REST",
        "trustStatus": "UNKNOWN",
        "handlesPii": false,
        "handlesSensitive": false
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    # Step 2: Get all to find the ID
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    When method get
    Then status 200
    * print "Response:", response
    * def endpointId = response[0].id

    # Step 3: Delete
    Given path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints', endpointId
    When method delete
    Then status 204

  Scenario: Create API endpoint with wrong parentType should fail
    And path 'applications', appId, 'serviceDefs', serviceDefId, 'apiEndpoints'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "parentServiceOrAgentId": "#(serviceDefId)",
        "parentType": "AGENT",
        "name": "Bad Endpoint"
      }
      """
    When method post
    Then status 400
