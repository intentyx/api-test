Feature: Test MCP Server Definitions List API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get All MCP Server Definitions
    Given path '/mcp-servers/mcpServerDefs'
    When method get
    Then status 200
    * print "MCP Server List Response:", response
    * match response.page == 0
    * match response.size == 50
    * match response.totalItems == '#number'
    * match response.totalPages == '#number'
    * match response.hasNext == '#boolean'
    * match response.hasPrev == false
    * match response.items == '#array'

  Scenario: Test Get All MCP Server Definitions with Custom Pagination
    Given path '/mcp-servers/mcpServerDefs'
    And param page = 1
    And param size = 10
    When method get
    Then status 200
    * print "Paginated MCP Server Response:", response
    * match response.page == 1
    * match response.size == 10
    * match response.totalItems == '#number'
    * match response.totalPages == '#number'
    * match response.hasNext == '#boolean'
    * match response.hasPrev == true
    * match response.items == '#array'


