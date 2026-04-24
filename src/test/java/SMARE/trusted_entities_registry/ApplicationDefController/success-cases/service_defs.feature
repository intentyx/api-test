Feature: Service Definitions CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    # Create an application to attach service defs to
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: CRUD for Service Definition
    # 1. Create
    Given path 'applications', appId, 'serviceDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appGuid": "#(appId)",
        "name": "Test Service",
        "description": "Service created for Karate",
        "trustStatus": "UNKNOWN"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    # 2. Get All to find ID
    Given path 'applications', appId, 'serviceDefs'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
    * def serviceDefId = response[0].id

    # 3. Get By ID
    Given path 'applications', appId, 'serviceDefs', serviceDefId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response.id == serviceDefId

    # 4. Update
    Given path 'applications', appId, 'serviceDefs', serviceDefId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(serviceDefId)",
        "appGuid": "#(appId)",
        "name": "Updated Test Service",
        "description": "Updated feature",
        "trustStatus": "UNKNOWN"
      }
      """
    When method put
    Then status 204

    # 5. Delete
    Given path 'applications', appId, 'serviceDefs', serviceDefId
    When method delete
    Then status 204
