# Feature 06: Integración Final y Lógica de Generación

## Descripción
Vincular todos los componentes creados: el botón "Generar", los parámetros configurados en la UI y los generadores de DNI. Al presionar el botón, el sistema debe leer los parámetros, generar una identidad válida y, basado en el tipo de DNI seleccionado, presentar en pantalla el PDF417 (viejo) o el QR (nuevo). 

## Criterios de Aceptación
1. Al hacer click en "Generar", el sistema debe verificar el estado de los parámetros numéricos y validar que min <= max.
2. Basado en el selector de tipo:
   - Si es "Versión Vieja", debe generar la identidad y mostrar un PDF417.
   - Si es "Versión Nueva", debe generar la identidad y mostrar un QR.
   - Si es "Aleatorio", debe escoger internamente (por ejemplo, con 50% de probabilidad) entre Versión Vieja y Versión Nueva en cada pulsación.
3. El área de visualización se debe actualizar dinámicamente con el nuevo código y los datos biográficos en texto plano para referencia del usuario debajo del gráfico.

## Pruebas Necesarias
- **Prueba de Integración (End-to-End):**
  - Simular el flujo completo del usuario: configurar valores (min, max, tipo), presionar el botón y confirmar que aparece un widget de código de barras o QR en pantalla junto con los textos correspondientes a la identidad.
  - Repetir el flujo seleccionando "Aleatorio" y presionar múltiples veces el botón, garantizando que no existan crash de la aplicación.
