Feature: Test Tool Definition by ID API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get Tool Definition by ID
    * def listResponse = call read('tools_list.feature@Scenario: Test Get All Tools with Default Pagination')
    * def toolDefId = listResponse.response.items[0].id
    Given path '/tools/' + toolDefId
    When method get
    Then status 200
    * print "Tool by ID Response:", response
    * match response.id == toolDefId
    * match response.appId == '#uuid'
    * match response.mcpId == '#uuid'
    * match response.agentId == '#uuid'
    * match response.name == '#string'
    * match response.title == '#string'
    * match response.description == '#string'
    * match response.version == '#string'
    * match response.trustStatus == '#string'
    * match response.createdAt == '#string'
    * match response.createdBy == '#string'
    * match response.lastUpdated == '#string'
    * match response.lastUpdatedBy == '#string'
    * match response.schemas == '#array'