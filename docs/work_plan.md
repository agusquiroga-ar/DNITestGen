# Plan de Trabajo - DNI Test Gen (Generador de Identidades y Códigos DNI)

## Descripción del Proyecto
El proyecto consiste en una aplicación de escritorio desarrollada en Flutter para Windows, cuyo principal objetivo es generar aleatoriamente credenciales de prueba similares a las del Documento Nacional de Identidad argentino.
La aplicación soporta la generación de los códigos de la versión antigua (PDF417) y de la versión nueva (eDNI QR).

## Metodología
El desarrollo seguirá un enfoque incremental ("Spec Driven Development"), donde la funcionalidad crece a medida que se va integrando cada nuevo requerimiento funcional (feature). Las tareas han sido secuenciadas para evitar bloqueos y minimizar las dependencias.

## Índice de Trabajo y Features

| Orden | Feature | Archivo de Especificación | Dependencias Previas | Complejidad |
| :---: | :--- | :--- | :--- | :--- |
| **1** | **Configuración Base de la Aplicación** | [01_base_application.md](file:///c:/dev/DNITestGen/docs/features/01_base_application.md) | Ninguna | Baja |
| **2** | **Modelos de Datos y Generador Aleatorio** | [02_data_models.md](file:///c:/dev/DNITestGen/docs/features/02_data_models.md) | Feature 1 | Media-Baja |
| **3** | **Parametría en Interfaz de Usuario** | [03_ui_parameters.md](file:///c:/dev/DNITestGen/docs/features/03_ui_parameters.md) | Feature 1 | Baja |
| **4** | **Generador de DNI Versión Vieja (PDF417)** | [04_old_dni_generator.md](file:///c:/dev/DNITestGen/docs/features/04_old_dni_generator.md) | Feature 2 | Media |
| **5** | **Generador de Nuevo eDNI (QR)** | [05_new_dni_generator.md](file:///c:/dev/DNITestGen/docs/features/05_new_dni_generator.md) | Feature 2 | Media |
| **6** | **Integración Final y Lógica de Generación** | [06_generator_integration.md](file:///c:/dev/DNITestGen/docs/features/06_generator_integration.md) | Features 3, 4 y 5 | Alta |

### Justificación del Orden de Implementación
1. **Feature 1** prepara el "cascarón" básico sin lógica pesada para no bloquear al resto.
2. **Feature 2** provee el motor de datos indispensable. Sin datos aleatorios no se puede graficar nada.
3. **Feature 3** añade la parametrización de UI en paralelo sin depender directamente del motor de gráficos.
4. **Features 4 y 5** son los motores de dibujado de cada tipo de código. Pueden desarrollarse de manera independiente una vez que existen los modelos de datos (Feature 2).
5. **Feature 6** une todo el proyecto: conecta los parámetros de la UI y los botones con la generación de las identidades aleatorias y el respectivo gráfico (PDF417 o QR).

## Instrucciones para el Agente Implementador
Lea secuencialmente cada uno de los archivos referenciados en este plan. Valide los "Criterios de Aceptación" y construya las pruebas recomendadas en la sección "Pruebas Necesarias" antes de dar por terminada la feature.
