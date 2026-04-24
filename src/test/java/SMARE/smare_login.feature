Feature: Test Auth

  Scenario: Get token
    Given url 'http://localhost:8080/smare/auth/login'
    And request { username: 'tenantadmin', password: 'admin' }
    And header Content-Type = 'application/json'
    And header x-tenant-name = 'DemoTenant'
    When method post
    Then status 200
    * print "Response:", response
    * def accessToken = response.accessToken
    * print 'Token:', accessToken
