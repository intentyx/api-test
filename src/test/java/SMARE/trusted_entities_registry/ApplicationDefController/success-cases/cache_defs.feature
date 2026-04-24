Feature: Cache Definitions CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'

    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: CRUD for Cache Definition
    Given path 'applications', appId, 'cacheDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "name": "Test Cache",
        "cacheType": "REDIS",
        "trustStatus": "UNKNOWN",
        "host": "localhost",
        "port": 6379,
        "protocol": "redis",
        "ttlSeconds": 3600
      }
      """
    When method post
    Then status 200
    * print "POST Response:", response

    # Contract Verification: Ensure GET returns a valid array
    Given path 'applications', appId, 'cacheDefs'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And match response == '#array'
    * print "GET response:", response
