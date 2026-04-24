Feature: Error Cases - MCP Server Definition by ID API

  Scenario: Test HTTP 400 Bad Request - Invalid UUID Format
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/mcp-servers/invalid-uuid-format'
    When method get
    Then status 400
    * print "Bad Request Response:", response


  Scenario: Test HTTP 401 Unauthorized - Invalid Token
    * url 'http://localhost:8080/smare'
    * header Authorization = 'Bearer invalid_token'
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    * def listResponse = call read('../mcp_server_def.feature@Scenario: Test Get All MCP Server Definitions with Default Pagination')
    * def mcpServerId = listResponse.response.items[0].id
    Given path '/mcp-servers/' + mcpServerId
    When method get
    Then status 401
    * print "Unauthorized Response:", response

  Scenario: Test HTTP 403 Forbidden

    Given url 'http://localhost:8080/smare/auth/login'
    And header Content-Type = 'application/json'
    And header x-tenant-name = 'DemoTenant'
    And request { username: 'no-op', password: 'admin' }
    When method post
    Then status 200

    * def accessToken = response.accessToken

    Given url 'http://localhost:8080/smare'
    And path '/mcp-servers/mcpServerDefs'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header x-tenant-name = 'null'
    When method get
    Then status 403

    * print "Forbidden Response:", response

  Scenario: Test HTTP 404 Not Found - Non-existent MCP Server ID
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'
    Given path '/mcp-servers/550e8400-e29b-41d4-a716-446655440000'
    When method get
    Then status 404
    * print "Not Found Response:", response
    * match response.message == '#string'
