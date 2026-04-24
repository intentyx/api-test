Feature: Test Applications Summary API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get Applications Summary
    Given path '/applications/summary'
    When method get
    Then status 200
    * print "Applications Summary Response:", response
    * def expectedApplicationsSummary =
      """
      {
        "criticalApplications": 100,
        "highLlmCostApplications": 1000,
        "aiHeavyApplications": 10,
        "highSensitivityApplications": 1
      }
      """
    * match response == expectedApplicationsSummary
    * assert response.criticalApplications == 100
    * assert response.highLlmCostApplications == 1000
    * assert response.aiHeavyApplications == 10
    * assert response.highSensitivityApplications == 1

