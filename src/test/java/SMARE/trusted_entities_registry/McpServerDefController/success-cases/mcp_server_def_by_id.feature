Feature: Test MCP Server Definition by ID API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get MCP Server Definition by ID
    # First get a valid MCP Server ID from the LIST endpoint (not summary)
    * def listResponse = call read('mcp_server_def.feature@Scenario: Test Get All MCP Server Definitions with Default Pagination')
    * def mcpServerId = listResponse.response.items[0].id
    Given path '/mcp-servers/' + mcpServerId
    When method get
    Then status 200
    * print "MCP Server by ID Response:", response
    * match response.id == mcpServerId
    * match response.name == '#string'
    * match response.title == '#string'
    * match response.websiteUrl == '#string'
    * match response.version == '#string'
    * match response.trustStatus == '#string'
    * match response.toolsCapability == '#boolean'
    * match response.resourcesCapability == '#boolean'
    * match response.promptsCapability == '#boolean'
    * match response.createdAt == '#string'
    * match response.createdBy == '#string'
    * match response.lastUpdated == '#string'
    * match response.lastUpdatedBy == '#string'
    * match response.tools == '#array'


