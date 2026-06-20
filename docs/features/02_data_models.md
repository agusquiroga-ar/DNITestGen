# Feature 02: Modelos de Datos y Generador Aleatorio

## Descripción
Implementar la lógica para leer y procesar diccionarios de datos en formato JSON para nombres y apellidos. Crear un servicio que sea capaz de generar aleatoriamente un conjunto de datos ficticios (nombre, apellido, fecha de nacimiento, sexo, número de trámite, ejemplar) y un número de DNI dentro de un rango especificado.

## Criterios de Aceptación
1. Deben existir dos archivos JSON en `assets/` (o generados en memoria/mock) que contengan listas de nombres y apellidos.
2. El sistema debe poder leer y deserializar los archivos JSON al iniciar.
3. Crear un servicio `DataGeneratorService` que provea la función de generar una "Identidad" aleatoria.
4. La generación del DNI debe aceptar como parámetros un valor mínimo y máximo.
5. El sexo debe ser seleccionado aleatoriamente entre 'M', 'F' o 'X'.
6. El ejemplar debe ser generado aleatoriamente (ej. 'A', 'B', 'C').
7. El número de trámite debe ser de 9 dígitos.

## Pruebas Necesarias
- **Pruebas Unitarias:**
  - Validar que el parsing de los JSON devuelva listas no vacías.
  - Asegurar que la función de generación aleatoria devuelve nombres y apellidos pertenecientes al JSON.
  - Validar que el DNI generado respeta los límites mínimo y máximo ingresados.
  - Comprobar que los campos como `sexo` y `ejemplar` se generan con valores permitidos.
  - Verificar que el número de trámite generado tiene exactamente 9 dígitos.
