Feature: Error Cases - RDBMS Definitions API

  Scenario: Test HTTP 400 Bad Request - Invalid UUID Format
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/applications/invalid-uuid-format/rdbmsDefs'
    When method get
    Then status 400
    * print "Bad Request Response:", response
    * match response.message == '#string'

  Scenario: Test HTTP 401 Unauthorized - Missing Token
    * url 'http://localhost:8080/smare'
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/applications/test-app-id/rdbmsDefs'
    When method get
    Then status 401
    * print "Unauthorized Response:", response
    * match response.message == '#string'

  Scenario: Test HTTP 500 Internal Server Error - Invalid Token
    * url 'http://localhost:8080/smare'
    * header Authorization = 'Bearer invalid_token'
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/applications/test-app-id/rdbmsDefs'
    When method get
    Then status 500
    * print "Internal Server Error Response:", response
    * match response.error == 'Internal Server Error'

  Scenario: Test HTTP 403 Forbidden
    Given url 'http://localhost:8080/smare/auth/login'
    And header Content-Type = 'application/json'
    And header x-tenant-name = 'DemoTenant'
    And request { username: 'no-op', password: 'admin' }
    When method post
    Then status 200

    * def accessToken = response.accessToken

    Given url 'http://localhost:8080/smare'
    And path '/applications/test-app-id/rdbmsDefs'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header x-tenant-name = 'null'
    When method get
    Then status 403
    * print "Forbidden Response:", response

  Scenario: Test HTTP 404 Not Found - Invalid Application ID
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/applications/1111111-1111-1111-1111-111111111999/rdbmsDefs'
    When method get
    Then status 404
    * print "Not Found Response:", response

  Scenario: Test HTTP 400 Bad Request - Invalid Request Body for Create
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/applications/test-app-id/rdbmsDefs'
    And request { invalid_field: 'test' }
    When method post
    Then status 400
    * print "Bad Request Response:", response
    * match response.message == '#string'
