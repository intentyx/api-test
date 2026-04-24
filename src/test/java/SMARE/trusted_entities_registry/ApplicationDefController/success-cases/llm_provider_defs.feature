Feature: LLM Provider

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * configure headers = { Authorization: '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: Read Operations for LLM Providers
    Given path 'applications', appId, 'llmProviderDefs'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
