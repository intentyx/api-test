Feature: RDBMS Definitions CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: CRUD for RDBMS Definition
    # 1. Create
    Given path 'applications', appId, 'rdbmsDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "name": "Test RDBMS",
        "dbType": "POSTGRES",
        "trustStatus": "UNKNOWN",
        "host": "localhost",
        "port": 5432,
        "protocol": "postgresql",
        "dbName": "testdb",
        "jdbcUrl": "jdbc:postgresql://localhost:5432/testdb"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    # Wait a moment for the RDBMS definition to be persisted
    * eval java.lang.Thread.sleep(300)

    # 2. Get By ID (using the ID from the response)
    * def rdbmsDefId = response.id
    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response

