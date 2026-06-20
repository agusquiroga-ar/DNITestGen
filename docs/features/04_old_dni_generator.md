# Feature 04: Generador de DNI Versión Vieja (PDF417)

## Descripción
Implementar la lógica para construir la cadena de texto con formato PDF417 según la especificación del DNI antiguo. Incorporar una librería (ej. `pdf417_barcode` o equivalente) para renderizar gráficamente el código de barras bidimensional en la interfaz.

## Criterios de Aceptación
1. Crear una función que tome el objeto de Identidad (generado en Feature 02) y devuelva un string delimitado por `@` con el formato esperado: `NroTramite@Apellido@Nombre@Sexo@DNI@Ejemplar@FechaNac@FechaEmision@Codigo`.
2. Asegurar que las fechas estén en formato `DD/MM/AAAA`.
3. Asegurar que apellidos y nombres estén en mayúsculas.
4. Mostrar un widget que grafique visualmente el string generado en formato de código de barras PDF417 en el área de visualización.

## Pruebas Necesarias
- **Prueba Unitaria:**
  - Validar que la cadena devuelta contenga exactamente 9 campos separados por 8 caracteres `@`.
  - Asegurar el correcto formateo de las fechas a `DD/MM/AAAA`.
  - Comprobar que los datos en texto coinciden con los del modelo de Identidad (mayúsculas, ceros no removidos, etc).
- **Prueba de Widgets:**
  - Verificar que el widget renderizador de PDF417 existe en el árbol de widgets cuando se pasa una cadena válida.
