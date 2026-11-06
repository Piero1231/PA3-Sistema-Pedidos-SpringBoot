
# Sistema de Pedidos — Spring Boot

**Curso:** Desarrollo de Aplicaciones Empresariales Avanzado  
**Institución:** ISIL  
**Proyecto:** Sistema de Pedidos  
**Tecnologías principales:** Java 21, Spring Boot 4.1.1, Spring MVC, Spring Security, Spring JDBC, Spring Data JPA y MySQL.

## 1. Descripción del proyecto

Sistema web desarrollado con Spring Boot para gestionar pedidos, consultar productos de un servicio externo de inventario y generar reportes.

El proyecto representa la migración de una aplicación Jakarta EE hacia Spring Boot, manteniendo la integración HTTP con inventario-service, desplegado independientemente en WildFly.

Se implementaron funcionalidades de seguridad, persistencia, consultas avanzadas y reportes utilizando una arquitectura por capas.

## 2. Objetivos

- Implementar una aplicación empresarial con Spring Boot.
- Utilizar Spring MVC para gestionar solicitudes HTTP.
- Aplicar inyección de dependencias.
- Integrar servicios externos mediante HTTP y JSON.
- Implementar persistencia con Spring Data JPA.
- Incorporar consultas SQL mediante Spring JDBC.
- Proteger la aplicación con Spring Security.
- Implementar autenticación, autorización y protección CSRF.
- Desarrollar pruebas automatizadas con JUnit, Mockito y MockMvc.

## 3. Tecnologías utilizadas

| Tecnología | Función |
|---|---|
| Java 21 | Lenguaje de programación |
| Spring Boot 4.1.1 | Framework principal |
| Spring MVC | Controladores y vistas |
| Spring Security | Autenticación y autorización |
| Spring Data JPA | Persistencia de pedidos |
| Spring JDBC | Consultas y reportes SQL |
| MySQL | Base de datos principal |
| H2 | Base de datos para pruebas |
| JSP | Interfaz web |
| Maven | Gestión de dependencias |
| JUnit 5 | Pruebas automatizadas |
| Mockito | Simulación de dependencias |
| MockMvc | Pruebas de controladores |
| Postman | Pruebas de servicios REST |
| WildFly | Servidor de inventario-service |
| Spring RestClient | Comunicación con inventario |

## 4. Arquitectura del sistema

La aplicación utiliza una arquitectura por capas:

```text
Navegador / Postman
         |
         v
   Spring Security
         |
         v
   Spring MVC
         |
         v
     Controllers
         |
         v
    PedidoService
         |
    +----+------------------+
    |                       |
    v                       v
Spring Data JPA         Spring JDBC
    |                       |
    +-----------+-----------+
                |
                v
           MySQL
           pedidosdb

Integración externa:

PedidoService
     |
     v
InventarioRestClient
     |
     v
HTTP / JSON
     |
     v
inventario-service
Jakarta EE / WildFly
     |
     v
SQL Server
```

La seguridad intercepta las solicitudes antes de permitir el acceso a los controladores.

## 5. Estructura del proyecto

```text
sistema-pedidos-springboot/
|
|-- pom.xml
|-- mvnw
|-- mvnw.cmd
|-- README.md
|
|-- src/
    |
    |-- main/
    |   |
    |   |-- java/com/isil/edu/pe/spedidos/
    |   |   |-- client/
    |   |   |-- config/
    |   |   |-- controller/
    |   |   |-- entity/
    |   |   |-- exception/
    |   |   |-- repository/
    |   |   |-- service/
    |   |
    |   |-- resources/
    |   |   |-- application.properties
    |   |
    |   |-- webapp/
    |       |-- WEB-INF/views/
    |           |-- pedidos.jsp
    |           |-- reportes-pedidos.jsp
    |
    |-- test/
        |-- java/
        |-- resources/
            |-- application-test.properties
```

## 6. Configuración y requisitos

Para ejecutar el proyecto se necesita:

- JDK 21.
- MySQL disponible.
- Maven Wrapper incluido en el proyecto.
- WildFly con inventario-service desplegado.
- Puerto 8081 disponible para Spring Boot.
- Puerto 8080 disponible para WildFly.

### Configuración principal

Archivo:

`src/main/resources/application.properties`

Configuración relevante:

```properties
server.port=8081
server.servlet.context-path=/sistema-pedidos

spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

La base de datos utilizada para la ejecución local es:

```text
pedidosdb
```

La configuración de conexión MySQL, las credenciales y la URL del servicio de inventario deben mantenerse de acuerdo con el entorno local.

La aplicación utiliza H2 en memoria para las pruebas automatizadas mediante el perfil `test`.

## 7. Ejecución del proyecto

### Paso 1. Iniciar MySQL

Verificar que MySQL esté ejecutándose y que exista la base de datos `pedidosdb`.

### Paso 2. Iniciar inventario-service

Iniciar WildFly y verificar que el servicio `inventario-service` esté desplegado correctamente.

### Paso 3. Compilar el proyecto

Desde PowerShell, dentro de la carpeta del proyecto:

```powershell
.\mvnw.cmd package -DskipTests
```

### Paso 4. Ejecutar la aplicación

```powershell
java -jar .\target\sistema-pedidos-springboot.war
```

### Paso 5. Acceder desde el navegador

Pantalla principal:

http://localhost:8081/sistema-pedidos/pedidos

Pantalla de reportes:

http://localhost:8081/sistema-pedidos/reportes/pedidos

Formulario de autenticación:

http://localhost:8081/sistema-pedidos/login

## 8. Funcionalidades implementadas

### Gestión de pedidos

- Consultar productos disponibles.
- Registrar pedidos.
- Validar cantidades y datos ingresados.
- Consultar pedidos registrados.
- Integrar operaciones con inventario-service.
- Persistir información mediante Spring Data JPA.

### Reportes con Spring JDBC

- Consultar pedidos mediante filtros.
- Buscar pedidos por cliente.
- Filtrar pedidos por monto mínimo.
- Consultar clientes frecuentes.
- Calcular cantidades y montos acumulados.
- Mostrar resultados mediante una interfaz JSP.
- Exponer resultados mediante servicios REST.

### Consultas SQL

Se utiliza `NamedParameterJdbcTemplate` para ejecutar consultas parametrizadas.

También se utilizan operaciones SQL como:

- SELECT
- WHERE
- LIKE
- GROUP BY
- HAVING
- ORDER BY
- COUNT
- SUM
- AVG

Las consultas de reportes son de solo lectura.

## 9. Endpoints REST

Los endpoints se muestran sin el prefijo `/sistema-pedidos`.

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /api/v1/orders | Listar pedidos |
| GET | /api/v1/orders/resumen | Resumen de pedidos |
| GET | /api/v1/pedidos | Consultar pedidos |
| GET | /api/v1/pedidos/estadisticas/resumen | Estadísticas generales |
| GET | /api/v1/pedidos/estadisticas/productos | Estadísticas por producto |
| GET | /api/v1/pedidos/busqueda-avanzada | Buscar pedidos con filtros |
| GET | /api/v1/pedidos/clientes-frecuentes | Consultar clientes frecuentes |

### Ejemplo de búsqueda avanzada

```http
GET /sistema-pedidos/api/v1/pedidos/busqueda-avanzada?cliente=Ana&totalMinimo=1000
```

Permite obtener pedidos del cliente indicado cuyo total cumple el monto mínimo.

### Ejemplo de clientes frecuentes

```http
GET /sistema-pedidos/api/v1/pedidos/clientes-frecuentes?minPedidos=1
```

Permite consultar clientes agrupados por número de pedidos.

La respuesta incluye información como:

- Cliente.
- Total de pedidos.
- Total de unidades.
- Importe acumulado.
- Ticket promedio.

## 10. Modelo de Madurez de Richardson

El proyecto incorpora ejemplos académicos de diferentes niveles del modelo de Richardson.

### Nivel 1: Recursos

```http
GET /api/v1/pedidos?cliente=Ana
```

Se utilizan recursos identificados mediante URI y filtros por parámetros de consulta.

### Nivel 2: Verbos HTTP

```http
GET /api/v1/pedidos/estadisticas/resumen
```

Se utilizan métodos y códigos HTTP para consultar información.

### Nivel 3: Hipermedia

```http
GET /api/v1/pedidos/estadisticas/productos
```

La respuesta utiliza HAL/HATEOAS e incluye enlaces para navegar hacia otros recursos relacionados.

Estos endpoints permiten demostrar conceptos del modelo de Richardson con fines académicos.

## 11. Seguridad con Spring Security

Se implementaron mecanismos de autenticación y autorización utilizando Spring Security.

### Autenticación

La aplicación permite autenticación mediante:

- Formulario de inicio de sesión.
- HTTP Basic para clientes como Postman.

Los usuarios de laboratorio se administran mediante `InMemoryUserDetailsManager`.

Las contraseñas se codifican utilizando BCrypt.

### Roles

**OPERADOR**

Puede consultar pedidos, acceder a reportes y registrar nuevos pedidos.

**CONSULTA**

Puede consultar pedidos y reportes, pero no registrar nuevos pedidos.

### Matriz de permisos

| Operación | OPERADOR | CONSULTA |
|---|---|---|
| Consultar pedidos | Permitido | Permitido |
| Consultar reportes | Permitido | Permitido |
| Consultar API REST | Permitido | Permitido |
| Registrar pedidos | Permitido | Denegado |
| Acceder sin autenticación | Denegado | Denegado |

### Protección CSRF

La protección CSRF permanece habilitada.

Los formularios POST incorporan un token CSRF válido para prevenir solicitudes no autorizadas.

Una solicitud POST sin token CSRF válido es rechazada con HTTP 403.

## 12. Pruebas de seguridad

Se realizaron pruebas manuales y automatizadas.

### Prueba 1. Acceso autorizado

Usuario: CONSULTA

Operación:

```http
GET /api/v1/pedidos/clientes-frecuentes?minPedidos=1
```

Resultado:

```text
HTTP 200 OK
```

### Prueba 2. Restricción por rol

Usuario: CONSULTA

Operación:

```http
POST /pedidos
```

Resultado:

```text
HTTP 403 Forbidden
```

Se comprueba que CONSULTA no puede registrar pedidos.

### Prueba 3. Registro autorizado

Usuario: OPERADOR

Operación:

```http
POST /pedidos
```

Resultado:

```text
HTTP 302 Found
```

El sistema redirige después de registrar correctamente el pedido.

### Prueba 4. Protección CSRF

Usuario: OPERADOR

Operación: solicitud POST sin token CSRF.

Resultado:

```text
HTTP 403 Forbidden
```

### Prueba 5. Usuario anónimo

Operación:

```http
GET /pedidos
```

Resultado en la prueba automatizada:

```text
HTTP 401 Unauthorized
```

Se verifica que el recurso protegido no puede consultarse sin autenticación.

## 13. Pruebas automatizadas

Las pruebas fueron implementadas utilizando JUnit 5, Mockito, MockMvc y Spring Security Test.

### Clases de pruebas

- PedidoApiControllerTest
- PedidoReporteControllerIntegrationTest
- PedidoSecurityIntegrationTest
- PedidoReporteJdbcRepositoryTest
- PedidoReportesNuevosTest
- PedidoServiceImplTest
- SistemaPedidosSpringbootApplicationTests

### Ejecución

Desde PowerShell:

```powershell
.\mvnw.cmd test
```

### Resultado final

```text
Tests run: 25
Failures: 0
Errors: 0
Skipped: 0

BUILD SUCCESS
```

Las pruebas verifican:

- Funcionamiento de los controladores.
- Contratos de respuesta JSON.
- Consultas de Spring JDBC.
- Lógica de negocio.
- Autorización por roles.
- Protección CSRF.
- Acceso autenticado.
- Carga del contexto Spring Boot.

Las pruebas de integración utilizan H2 para evitar depender de la base MySQL durante su ejecución.

## 14. Persistencia

### Spring Data JPA

Se utiliza para las operaciones de persistencia de pedidos.

### Spring JDBC

Se utiliza para consultas especializadas y reportes.

La clase `PedidoReporteJdbcRepository` encapsula consultas SQL parametrizadas.

Las consultas de reportes utilizan la misma fuente de datos que el módulo principal.

### Bases de datos

**MySQL:** almacenamiento principal de pedidos.

**H2:** ejecución de pruebas automatizadas.

## 15. Integración con inventario-service

La aplicación consume un servicio externo de inventario mediante HTTP y JSON.

La comunicación se realiza utilizando Spring RestClient.

```text
Sistema de Pedidos
    Spring Boot
         |
         v
InventarioRestClient
         |
         v
      HTTP/JSON
         |
         v
  inventario-service
     WildFly
```

El servicio externo permanece independiente y no fue modificado como parte de la migración del Sistema de Pedidos.

## 16. Interfaz web

La aplicación utiliza Spring MVC y JSP.

### pedidos.jsp

Permite:

- Visualizar productos.
- Registrar pedidos.
- Consultar pedidos.
- Mostrar mensajes de confirmación.
- Enviar formularios protegidos con CSRF.

### reportes-pedidos.jsp

Permite:

- Consultar reportes.
- Visualizar resultados de búsqueda avanzada.
- Consultar clientes frecuentes.
- Mostrar información mediante tablas HTML.

Las vistas fueron adaptadas para funcionar sin depender de etiquetas JSTL durante la ejecución del WAR.

## 17. Evidencias

Se recopilaron las siguientes evidencias:

| Evidencia | Descripción |
|---|---|
| Búsqueda avanzada | Consulta REST con filtros |
| Clientes frecuentes | Consulta REST y respuesta JSON |
| Acceso CONSULTA | HTTP 200 OK |
| Restricción CONSULTA | HTTP 403 Forbidden |
| Registro OPERADOR | Registro exitoso |
| Protección CSRF | HTTP 403 Forbidden |
| Pruebas automatizadas | 25 pruebas aprobadas |

Las capturas pueden incorporarse al informe académico para demostrar el funcionamiento de la aplicación.

## 18. Limitaciones

El proyecto fue desarrollado para fines académicos.

Actualmente:

- Los usuarios se administran en memoria.
- No se implementa autenticación JWT ni OAuth2.
- Las credenciales de laboratorio no deben utilizarse en producción.
- La integración con inventario depende de un servicio externo.
- No se implementan transacciones distribuidas.
- La aplicación está configurada principalmente para ejecución local.

Para un entorno productivo se recomienda utilizar HTTPS, gestión segura de credenciales, migraciones de base de datos y mecanismos adicionales de monitoreo.

## 19. Conclusiones

Se implementó un Sistema de Pedidos basado en Spring Boot que integra gestión de pedidos, persistencia, consultas SQL avanzadas, reportes y controles de seguridad.

Spring Data JPA permite administrar las operaciones principales, mientras que Spring JDBC facilita consultas especializadas y agregaciones.

Spring Security permite controlar el acceso por roles y proteger las operaciones mediante CSRF.

Finalmente, la ejecución exitosa de 25 pruebas automatizadas respalda el correcto funcionamiento de los componentes evaluados.

## 20. Referencias técnicas

- Spring Boot: https://docs.spring.io/spring-boot/reference/
- Spring MVC: https://docs.spring.io/spring-framework/reference/web/webmvc.html
- Spring Security: https://docs.spring.io/spring-security/reference/
- Spring JDBC: https://docs.spring.io/spring-framework/reference/data-access/jdbc.html
- Spring HATEOAS: https://spring.io/projects/spring-hateoas
- Richardson Maturity Model: https://martinfowler.com/articles/richardsonMaturityModel.html

---

**Proyecto académico — ISIL**  
**Curso:** Desarrollo de Aplicaciones Empresariales Avanzado
