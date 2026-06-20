# Feature 03: Parametría en Interfaz de Usuario

## Descripción
Agregar una sección de configuración en la pantalla principal, ubicada debajo del botón "Generar". Esta parametria permitirá al usuario definir qué tipo de documento desea generar (Versión Vieja, Versión Nueva, Aleatorio) y establecer el rango numérico (min y max) para el DNI generado.

## Criterios de Aceptación
1. Implementar un selector (dropdown o radio buttons) con tres opciones: "Versión Vieja", "Versión Nueva" y "Aleatorio".
2. Implementar dos campos de entrada de texto (TextFormField) para "DNI Mínimo" y "DNI Máximo".
3. Validar que los campos de mínimo y máximo solo acepten números enteros.
4. Validar que el valor mínimo no sea mayor al máximo.
5. Conectar estos parámetros con el estado global para que estén disponibles cuando se presione el botón "Generar".

## Pruebas Necesarias
- **Pruebas de Widgets:**
  - Verificar que los selectores de tipo de DNI existan en pantalla.
  - Comprobar que los campos numéricos existen y limitan el ingreso a solo dígitos.
  - Simular el llenado de los campos mínimo y máximo y verificar la validación (ej. min > max lanza error en UI).
- **Prueba de Integración:** Verificar que al cambiar los parámetros en la UI, el estado de la aplicación se actualiza con los valores correctos.
