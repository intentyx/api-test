Feature: Test MCP Servers Summary API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get MCP Servers Summary
    Given path '/mcp-servers/summary'
    When method get
    Then status 200
    * print "MCP Summary Response:", response
    * def expectedMcpSummary =
      """
      {
        "highRiskMcps": 200,
        "highBlastRadiusMcps": 2000,
        "dormantPrivilegedMcps": 20,
        "sensitiveToolsMcps": 2
      }
      """
    * match response == expectedMcpSummary
    * assert response.highRiskMcps == 200
    * assert response.highBlastRadiusMcps == 2000
    * assert response.dormantPrivilegedMcps == 20
    * assert response.sensitiveToolsMcps == 2
