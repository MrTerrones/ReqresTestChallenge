Feature: Feature Reusable
  COMO QA
  QUIERO obtener los usuarios totales
  PARA usarlo como dato en otros feature

  Scenario: Obtener usuario totales
    Given url baseUrl
    * path 'users'
    When method GET
    Then status 200
    * def countUsers = response.total
    * print countUsers