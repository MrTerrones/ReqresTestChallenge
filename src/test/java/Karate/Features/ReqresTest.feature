Feature: Plan de Pruebas Reqres
  COMO QA de NTTData
  QUIERO testear el API de Reqres
  PARA validar la estabilidad de sus consultas https

  Background:
    * call read("classpath:Karate/Features/FeatureReusable.feature")


  @ReqResAll @GetAllUser
  Scenario: Obtener Usuarios totales de la Lista
    Given url baseUrl
    * path 'users'
    * param per_page = countUsers
    * header Content-Type = 'application/json'
    When method GET
    Then status 200
    * print response


  @ReqResAll @GetRandomUser @HappyPath
  Scenario Outline: Obtener Usuarios con una funcion randomizada de segmento valido - OK

    * def max = countUsers
    * def min = 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min

    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    When method GET
    Then status 200
    * print response

    Examples:
      | id           |
      | randomUserId |
      | randomUserId |
      | randomUserId |

  @ReqResAll @GetRandomUser @UnhappyPath
  Scenario Outline: Obtener Usuarios con una funcion randomizada de segmento no valido - OKNO

    * def max = 999
    * def min = countUsers + 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min

    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    When method GET
    Then status 404
    * print response

    Examples:
      | id            |
      | randomUserId  |
      | -randomUserId |

  @ReqResAll @PostCreateUser @HappyPath
  Scenario Outline: Crear usuario <name> - <job> en Reqres  - OK

    * def solicitud = read("classpath:Karate/Data/User.json")

    Given url baseUrl
    * path 'users'
    * header Content-Type = 'application/json'
    * request solicitud
    When method POST
    Then status 201
    * print response

    Examples:
      | name  | job           |
      | Maria | Administrator |
      | Rapha | Engineer      |
      | Renzo | QA            |

  @ReqResAll @PostCreateUser @UnhappyPath
  Scenario Outline: Crear usuario con <nombreCaso> en Reqres  - OKNO
    Given url baseUrl
    * path 'users'
    * header Content-Type = 'application/json'
    * request
      """
      {
    "<name>": '<Vname>',
    "<job>": '<Vjob>'
      }
      """
    When method POST
    Then status 201
    * print response

    Examples:

      | read('classpath:Karate/Data/UserJobs.csv') |

  @ReqResAll @PutUser @HappyPath
  Scenario Outline: Actualizar w/PUT usuarios en Reqres mediante UserID validos - OK

    * def max = countUsers
    * def min = 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min


    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    * request
    """
    {
    "name": "<Vname>",
    "job": "<Vjob>"
}
    """
    When method PUT
    Then status 200
    * print response


    Examples:
      | id           | Vname | Vjob          |
      | randomUserId | Maria | Administrator |
      | randomUserId | Rapha | Engineer      |
      | randomUserId | Renzo | QA            |

  @ReqResAll @PutUser @UnhappyPath
  Scenario Outline: Actualizar w/PUT usuarios en Reqres mediante UserID no validos - OKNO

    * def max = 999
    * def min = countUsers + 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min


    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    * request
    """
    {
    "name": "<Vname>",
    "job": "<Vjob>"
}
    """
    When method PUT
    Then status 200
    * print response

    Examples:
      | id            | Vname | Vjob          |
      | randomUserId  | Maria | Administrator |
      | -randomUserId | Rapha | Engineer      |

  @ReqResAll @PatchUser @HappyPath
  Scenario Outline: Actualizar w/Patch usuarios en Reqres mediante UserID validos - OK

    * def max = countUsers
    * def min = 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min


    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    * request
    """
    {
    "name": "<Vname>"
    }
    """
    When method PATCH
    Then status 200
    * print response
    * match response.name == "<Vname>"


    Examples:
      | id           | Vname |
      | randomUserId | Maria |
      | randomUserId | Rapha |
      | randomUserId | Renzo |

  @ReqResAll @PatchUser @UnhappyPath
  Scenario Outline: Actualizar w/Patch usuarios en Reqres mediante UserID no validos - OKNO

    * def max = 999
    * def min = countUsers + 1
    * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min


    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    * request
    """
    {
    "job": "<Vjob>"
    }
    """
    When method PUT
    Then status 200
    * print response
    * match response.job == "<Vjob>"

    Examples:
      | id            | Vjob          |
      | randomUserId  | Administrator |
      | -randomUserId | Engineer      |

  @ReqResAll @DeleteUser
  Scenario Outline: Borrar un usuario de Reqres - OK

    Given url baseUrl
    * path 'users',<id>
    * header Content-Type = 'application/json'
    When method DELETE
    Then status 204

    Examples:
      | id |
      | 2  |