Feature: Test Tools List API

  Background:
    * url 'http://localhost:8080/smare'
    * def loginResult = call read('classpath:SMARE/smare_login.feature')
    * def accessToken = loginResult.accessToken
    * header Authorization = 'Bearer ' + accessToken
    * header Content-Type = 'application/json'
    * header x-tenant-name = 'DemoTenant'

  Scenario: Test Get All Tools with Default Pagination
    Given path '/tools/list'
    When method get
    Then status 200
    * print "Tools List Response:", response
    * match response.page == 0
    * match response.size == 50
    * match response.totalItems == '#number'
    * match response.totalPages == '#number'
    * match response.hasNext == '#boolean'
    * match response.hasPrev == false
    * match response.items == '#array'

