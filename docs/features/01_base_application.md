# Feature 01: Configuración Base de la Aplicación

## Descripción
Crear la estructura base de la aplicación Flutter con soporte para Windows. Implementar la pantalla principal con un botón "Generar" y un área de visualización (placeholder) donde se mostrarán los códigos en el futuro. Establecer el patrón de gestión de estado (por ejemplo, Provider, Riverpod o BLoC).

## Criterios de Aceptación
1. La aplicación debe poder compilarse y ejecutarse correctamente en Windows (`flutter run -d windows`).
2. La pantalla principal debe contener un título "Generador de DNI".
3. Debe existir un botón etiquetado "Generar".
4. Debe existir un contenedor debajo del botón que actúe como un placeholder (área de visualización vacía).
5. Se debe integrar un sistema de gestión de estado básico, preparado para las siguientes características.

## Pruebas Necesarias
- **Prueba Unitaria:** Verificar que el estado inicial de la aplicación se carga correctamente.
- **Prueba de Widgets:** 
  - Verificar la existencia del texto "Generador de DNI".
  - Verificar la existencia del botón "Generar".
  - Simular el tap en el botón "Generar" y asegurar que no produzca errores.
- **Prueba de Integración:** Verificar que la app inicia correctamente en el entorno de Windows sin excepciones.
