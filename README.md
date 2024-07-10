# Desafío de Automatización con Karate Framework para API reqres.in

Este proyecto tiene como objetivo evaluar las capacidades de automatización utilizando el framework Karate DSL frente al API de prueba reqres.in. A continuación, se detallan los aspectos clave del proyecto:

## 1. Resumen

El objetivo principal de este proyecto es demostrar competencias en el uso del framework Karate DSL para la automatización de pruebas de API. Se implementarán casos de prueba que cubran escenarios comunes y específicos del API de reqres.in, evaluando así el manejo de peticiones HTTP, manejo de respuestas y verificación de resultados.

## 2. Configuración Básica del Proyecto

Para configurar el entorno de desarrollo y ejecutar las pruebas automatizadas, sigue estos pasos:

- Asegúrate de tener instalado Java en tu sistema.
- Agrega las siguientes dependencias en tu archivo `pom.xml`:

```xml
<dependency>
    <groupId>com.intuit.karate</groupId>
    <artifactId>karate-junit5</artifactId>
    <version>1.2.0</version>
    <scope>test</scope>
</dependency>
```

Configura el plugin Maven Surefire para ejecutar las pruebas desde el directorio src/test/java:

```xml
 <build>
        <testResources>
            <testResource>
                <directory>src/test/java</directory>
                <excludes>
                    <exclude>**/*.java</exclude>
                </excludes>
            </testResource>
        </testResources>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>2.22.2</version>
            </plugin>
        </plugins>
    </build>
```
Además configura el archivo karate-config.js

```js

function fn() {
  var env = karate.env;
  karate.configure('ssl',true);
  karate.log('El ambiente donde se ejecutó es :', env);

  if (!env) {
    env = 'cert';
  }

  if (env == 'dev') {
   baseUrl = 'https://reqres.in/api';

  } else if (env == 'cert') {
    baseUrl = 'https://reqres.in/api';
  }

  var config = {
      env:env,
      baseUrl:baseUrl
    };

  // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}
```
La configuracion del logback-test.xml es opcional y lo puedes encontrar en el github de KarateLabs.

## 3. Estructura del Proyecto

El repositorio está organizado de la siguiente manera:

```
test/
└──java/
    └── Karate/
          ├── Data/
          ├── Features/
    └── Runners/
karate-config.js
logback-test.xml
```
- **Data/**: Contiene archivos de datos utilizados en los escenarios de prueba.
- **Features/**: Aquí se encuentran los archivos `.feature` que contienen los escenarios de prueba escritos en Karate.
- **Runners/**: Contiene clases de ejecución (`RunnerTest`) que integran los escenarios de prueba con anotaciones específicas.

## 4. Configuración de los Runners

En la carpeta `Runners`, encontrarás el archivo `RunnerTest.java`, que configura las pruebas con etiquetas específicas:

- `@ReqResAll`: Se aplica a todos los escenarios de prueba.
- `@HappyPath`: Se aplica a escenarios válidos.
- `@UnhappyPath`: Se utiliza para escenarios que prueban casos de error, según el método HTTP utilizado.

El archivo de RunnerTest esta configurado por defecto como: 

```java
class RunnerTest {

    @Karate.Test
    Karate testSystemProperty() {
        return Karate.run("classpath:Karate/Features/ReqresTest.feature")
                .tags("@ReqResAll")
                .karateEnv("cert");
    }

}
```
## 5. Escenarios de Pruebas

En este proyecto, se utiliza un archivo feature llamado `FeatureReusable.feature`, que contiene un único escenario para obtener la cantidad de usuarios registrados en el API. Este valor se lee y utiliza en el feature principal llamado `ReqresTest.feature`.

### Uso del Archivo FeatureReusable.feature

Este archivo es reutilizado en varios escenarios para:

1. Obtener el JSON con todos los usuarios.
2. Generar valores aleatorios dentro y fuera del rango válido.

### Uso del Archivo ReqresTest.feature

Este archivo comprende el uso de operacion CRUD como fueron mencionados anteriormente además de:

1. Realizar lecturas de archivos JSON y CSV para la obtención de datos en los casos de prueba de tipo `Outline`.
```gherkin
* def solicitud = read("classpath:Karate/Data/User.json")
```
3. Incluir JSON en línea dentro de los escenarios cuando sea necesario.
```gherkin
 * request
      """
      {
    "<name>": '<Vname>',
    "<job>": '<Vjob>'
      }
      """
```   
5. Randomizar id de Usuarios según los rangos permitidos.
```gherkin
  * def max = countUsers
  * def min = 1
  * def randomUserId = Math.floor(Math.random() * (max - min + 1)) + min
```

Este enfoque de reutilización de escenarios y datos facilita la creación de pruebas automatizadas robustas y flexibles utilizando el framework Karate DSL.

## 6. Manejo de Respuestas del API

Durante las pruebas, se observó el siguiente comportamiento del API de reqres.in:

- **Códigos de Respuesta Esperados**:
  - Consultas exitosas (`GET`): `200`
  - Creación de usuario (`POST`): `201`
  - Actualización de usuario (`PUT`, `PATCH`): `200`
  - Eliminación de usuario (`DELETE`): `204`

- **Casuística Unhappy**:
  - El API reconoce el estado `404` para consultas inválidas.
  - Para creación, reconoce `201` aunque el ID sea inválido según lo esperado.
  - Para actualización, reconoce `200` aunque el ID sea inválido según lo esperado.

## 7. Conclusiones

Basado en las pruebas realizadas utilizando Karate DSL con el API de reqres.in, se identificaron áreas de mejora y recomendaciones para el desarrollo y mantenimiento del API:

- **Claridad en los Códigos de Respuesta**: Aunque el API maneja correctamente los códigos de respuesta estándar como `200`, `201`, y `204`, se observó una inconsistencia en el manejo de códigos en casos de errores específicos. Se recomienda alinear el manejo de códigos de respuesta para casos de error.
  
- **Mejora en la Documentación de API**: Existe una oportunidad para mejorar la documentación del API, especialmente en la especificación de los códigos de respuesta esperados y el comportamiento ante casos de error específicos.

- **Optimización en la Validación de Entradas**: Se observó que el API acepta entradas inválidas en operaciones de creación o actualización, devolviendo códigos de respuesta `200` o `201`. Se recomienda mejorar la validación de entradas para asegurar que solo se acepten datos válidos según las especificaciones del API.

- **Uso Eficiente de Recursos en Pruebas**: La reutilización de escenarios y datos en los archivos de características (`FeatureReusable.feature`) demostró ser efectiva para generar casos de prueba variados y robustos. 

## Mensaje Final

Como profesional en QA, considero que el framework Karate DSL ofrece herramientas poderosas para la automatización de pruebas de API. Durante este proyecto, he aprendido mucho y he visto el potencial de Karate en acción. Continuaré explorando y mejorando mis habilidades en la automatización de pruebas, ya que considero esta área no solo como una responsabilidad, sino como una pasión.

