# Laboratorio Semana 12 · Sesión 23

Aplicación MVC de empleados con Java, JSF 2.2.20, EL y Apache Tomcat 9.0.123. Proyecto Maven WAR preparado para Visual Studio Code; también puede abrirse como proyecto Maven en NetBeans.

## Ejecutar en Visual Studio Code

1. Abrir esta carpeta en VS Code. Se recomienda Extension Pack for Java.
2. Ejecutar **Terminal → Ejecutar tarea → Laboratorio: iniciar Tomcat**, o pulsar Ctrl+Shift+B.
3. Abrir http://localhost:8088/taller-s12s23/lista_empleados.xhtml.
4. Para detener: **Terminal → Ejecutar tarea → Laboratorio: detener Tomcat**. Detener antes de recompilar y reiniciar.

También: `powershell -ExecutionPolicy Bypass -File scripts/iniciar.ps1`.
Se usa 8088 porque 8080 está ocupado por WildFly en este equipo. Si 8080 queda libre, ejecutar `scripts/iniciar.ps1 -Port 8080` y cambiar el puerto de la URL.

Requisitos: JDK 11 o superior y Maven en PATH. El script también detecta el Maven incluido en NetBeans 12 de este equipo y descarga Tomcat con verificación SHA512 cuando no existe en `.runtime`. Requiere Internet para dependencias iniciales. No usar Tomcat 10/11 directamente: cambian los paquetes javax a jakarta. Las anotaciones JSF clásicas del enunciado se conservan deliberadamente.

## Correspondencia con la práctica

- `src/main/java/com/utp/model/Empleado.java`: POJO, cinco atributos privados, constructores y accesores; serializable para el estado de vista.
- `src/main/java/com/utp/controller/EmpleadoController.java`: `@ManagedBean(name="empleadoController")`, `@ViewScoped`, lista privada y cinco registros en `@PostConstruct`.
- `src/main/webapp/lista_empleados.xhtml`: formulario maestro, `h:dataTable` con `var="emp"`, ID, nombre, cargo, sueldo y estado ternario. `empty` / `not empty`, resta, `and` y `gt` para contadores y renderizado condicional.
- Los botones permiten comprobar la conservación del estado en varios postbacks AJAX, vaciar y restaurar la lista. Al abrir una nueva vista se cargan los datos iniciales. No hay persistencia después de reiniciar ni base de datos; el enunciado pide datos de prueba en memoria.
- Los nombres y sueldos son ficticios y plausibles; no corresponden a datos personales verificados de empleados reales.

## Pruebas y evidencias

`evidencias/resultado-pruebas.json` registra los resultados automatizados del navegador. Capturas: listado inicial, cambios consecutivos, lista vacía, móvil y ejecución junto al código XHTML. La última es una composición identificada de una captura real y el archivo fuente original.

Para repetir las pruebas instalar Playwright en un directorio de herramientas, establecer `PLAYWRIGHT_PATH` a su módulo y ejecutar `node scripts/verificar.cjs` con Chrome y Tomcat disponibles.

Logs del servidor en `.runtime/tomcat-error.log` y `.runtime/tomcat-out.log`. WAR en `target/taller-s12s23.war`. El ZIP de entrega contiene fuentes, configuración, scripts, evidencias y WAR; omite herramientas temporales. Subir el ZIP a Canvas UTP manualmente según indicaciones del docente.

Referencias: https://tomcat.apache.org/migration-10 y https://javaee.github.io/javaserverfaces/docs/2.3/managed-bean-javadocs/javax/faces/bean/ManagedBean.html.
