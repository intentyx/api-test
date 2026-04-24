Feature: Test Tools Summary API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get Tools Summary
    Given path '/tools/summary'
    When method get
    Then status 200
    * print "Tools Summary Response:", response
    * def expectedToolSummary =
      """
      {
        "highRiskTools": 300,
        "highBlastRadiusTools": 3000,
        "dormantPrivilegedTools": 30,
        "externallyConnectedTools": 3
      }
      """
    * match response == expectedToolSummary
    * assert response.highRiskTools == 300
    * assert response.highBlastRadiusTools == 3000
    * assert response.dormantPrivilegedTools == 30
    * assert response.externallyConnectedTools == 3
