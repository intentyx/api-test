Feature: RDBMS Schemas and Tables  CRUD

  Background:
    * def authResponse = karate.call('classpath:SMARE/smare_login.feature')
    * def accessToken = authResponse.accessToken
    * configure headers = { Authorization: '#("Bearer " + accessToken)', 'x-tenant-name': 'DemoTenant' }
    * url 'http://localhost:8080/smare'

    * def createApp = karate.call('create_application.feature')
    * def appId = createApp.createdAppId

    Given path 'applications', appId, 'rdbmsDefs'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "appId": "#(appId)",
        "name": "DB For Schemas",
        "dbType": "POSTGRES",
        "trustStatus": "UNKNOWN",
        "host": "localhost",
        "port": 5432,
        "protocol": "postgresql",
        "dbName": "testdb",
        "jdbcUrl": "jdbc:postgresql://localhost:5432/testdb"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    Given path 'applications', appId, 'rdbmsDefs'
    When method get
    Then status 200
    * print "Response:", response
    * def rdbmsDefId = response[0].id

  Scenario: Minimal Hierarchy CRUD for Schemas & Tables
    # 1. Create Schema
    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId, 'schemas'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "public",
        "description": "Default public schema"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId, 'schemas'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
    * def schemaId = response[0].id

    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId, 'schemas', schemaId, 'tables'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "users_table",
        "description": "Users table for testing"
      }
      """
    When method post
    Then status 200
    * print "Response:", response

    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId, 'schemas', schemaId, 'tables'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    * print "Response:", response
    And match response == '#array'
    * def tableId = response[0].id

    Given path 'applications', appId, 'rdbmsDefs', rdbmsDefId, 'schemas', schemaId, 'tables', tableId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "id": "#(tableId)",
        "name": "updated_users_table",
        "description": "Updated description"
      }
      """
    When method put
    Then status 200
    * print "Response:", response
