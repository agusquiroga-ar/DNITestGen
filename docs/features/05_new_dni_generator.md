# Feature 05: Generador de Nuevo eDNI (QR)

## Descripción
Implementar la lógica para construir la URL de validación parametrizada que se requiere para el nuevo DNI electrónico. Integrar una librería (ej. `qr_flutter`) para renderizar el código QR en la aplicación cumpliendo con las especificaciones técnicas (Nivel de error M, margen mínimo, alto contraste).

## Criterios de Aceptación
1. Crear una función que tome el objeto de Identidad y retorne una URL con el formato: `https://mitramite.renaper.gob.ar/validar?id={id}&dni={dni}&sexo={sexo}&ejemplar={ejemplar}`.
2. Validar que el parámetro `id` posea exactamente 9 dígitos, y que el DNI no posea puntos.
3. Mostrar un widget que grafique visualmente el QR correspondiente a la URL generada en el área de visualización.
4. Asegurar que el QR se renderiza con Error Correction Level M y con colores blanco y negro.

## Pruebas Necesarias
- **Prueba Unitaria:**
  - Validar que la URL generada contenga correctamente inyectados los parámetros del modelo de identidad.
  - Asegurar que se lance una excepción si el `id` no tiene 9 dígitos.
- **Prueba de Widgets:**
  - Comprobar que el widget renderizador del QR existe en el árbol de widgets cuando se pasa una URL válida y que los colores configurados son correctos.
