Feature: Tool Schemas and Tool Properties Read Operations

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * configure headers = { Authorization: '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: Read Operations for Tools and Properties
    * def toolDefId = java.util.UUID.randomUUID()
    * def toolSchemaDefId = java.util.UUID.randomUUID()

    Given path 'applications', appId, 'tools', toolDefId, 'schemas'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'

    Given path 'applications', appId, 'toolSchema', toolSchemaDefId, 'toolProperties'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
