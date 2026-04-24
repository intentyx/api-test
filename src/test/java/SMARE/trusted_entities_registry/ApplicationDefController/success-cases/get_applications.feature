Feature: Get All Applications API Testing

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }

  Scenario: Get all applications
    Given url 'http://localhost:8080/smare'
    And path 'applications'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response