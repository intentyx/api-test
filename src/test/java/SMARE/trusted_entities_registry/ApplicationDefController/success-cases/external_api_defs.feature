Feature: External API Definitions CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * def bearerToken = 'Bearer ' + accessToken
    * configure headers = { Authorization: '#(bearerToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'
    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

  Scenario: CRUD for External API Definition
    * configure retry = { count: 10, interval: 1000 }
    Given path 'applications', appId, 'externalApiDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "name": "Test External API",
        "trustStatus": "UNKNOWN",
        "host": "api.example.com",
        "port": 443,
        "protocol": "https",
        "baseUrl": "https://api.example.com",
        "authType": "Bearer"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    # 3. Get All to find ID (Using retry to handle potential cache delays)
    Given path 'applications', appId, 'externalApiDefs'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
#    * def externalApiDefId = response[0].id

    # 4. Get by ID
#    Given path 'applications', appId, 'externalApiDefs', externalApiDefId
#    And header Content-Type = 'application/json'
#    When method get
#    Then status 200
#    * print "Response:", response
##    And match response.id == externalApiDefId

#    # 4. Update
#    Given path 'applications', appId, 'externalApiDefs', externalApiDefId
#    And header Content-Type = 'application/json'
#    And request
#      """
#      {
#        "id": "#(externalApiDefId)",
#        "appId": "#(appId)",
#        "name": "Updated External API",
#        "trustStatus": "TRUSTED",
#        "host": "api.example.com",
#        "port": 443,
#        "protocol": "https",
#        "baseUrl": "https://api.example.com",
#        "authType": "Bearer"
#      }
#      """
    # When method put
    # Then status 204
    # * print "Update operation succeeded for external API definition"
#
    # # Verify the update worked
    # Given path 'applications', appId, 'externalApiDefs', externalApiDefId
    # And header Content-Type = 'application/json'
    # When method get
    # Then status 200
    # * match response.name == 'Updated External API'
    # * match response.trustStatus == 'TRUSTED'

    # 5. Delete
#    Given path 'applications', appId, 'externalApiDefs', externalApiDefId
#    When method delete
#    Then status 204
