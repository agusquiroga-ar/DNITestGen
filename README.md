# DNI Test Gen

**DNI Test Gen** es una aplicación de escritorio desarrollada en Flutter para Windows diseñada para asistir en el proceso de Quality Assurance (QA). 

> ⚠️ **IMPORTANTE:** Esta aplicación **únicamente genera los códigos escaneables (QR y de barras PDF417)** con datos biográficos ficticios y aleatorios. **No** genera plantillas gráficas, fotografías, imágenes ni ninguna representación visual de la tarjeta física del DNI. Su propósito es exclusivo para probar procesos de escaneo e integración en sistemas de desarrollo y QA.
## Características

*   **Soporte Multiformato:** Genera códigos acordes a dos normativas vigentes en Argentina:
    *   **DNI Versión Vieja (PDF417):** Estructura los datos biográficos bajo un formato separado por `@` renderizando un código de barras PDF417.
    *   **Nuevo eDNI (QR):** Construye la URL de validación parametrizada oficial (ej: `mitramite.renaper.gob.ar/validar?...`) renderizando el código QR con su respectivo Nivel de Corrección (M).
*   **Generador Aleatorio Ficticio:**
    *   Selecciona aleatoriamente nombres y apellidos de diccionarios pre-cargados (`assets/names.json` y `assets/surnames.json`).
    *   Genera un Número de Trámite válido de exactamente 9 dígitos.
    *   Asigna géneros válidos (`M`, `F`, `X`) y diferentes letras de ejemplares.
    *   Genera fechas lógicas de nacimiento y emisión.
*   **Parametría Configurable:**
    *   Selección del Tipo de DNI (Viejo, Nuevo o 50/50 Aleatorio).
    *   Límites configurables para acotar la generación del DNI (Rango Numérico Mínimo y Máximo).
*   **Inspección Visual Rápida:** Muestra tanto el código generado para el escáner físico como los datos biográficos en texto plano por debajo de este.

## Arquitectura y Patrones

La aplicación fue desarrollada utilizando metodologías de *Spec Driven Development* dividiendo el alcance en pequeños incrementos o "features":

1.  **Gestor de Estado (Provider):** Desacoplamiento de la lógica de negocio a través de `ChangeNotifierProvider` en `lib/main.dart`.
2.  **Modelos de Datos (`lib/models/`):** Estructuras limpias para encapsular la Identidad generada (`identity.dart`).
3.  **Generadores Independientes (`lib/generators/`):** Clases utilitarias aisladas (`old_dni_generator.dart` y `new_dni_generator.dart`) que se responsabilizan individualmente por los formatos de texto y dependencias de renderizado gráfico (`barcode_widget`, `qr_flutter`).
4.  **Servicios Falsos/Mocking (`lib/services/`):** `data_generator_service.dart` aísla las reglas de creación del RNG (Random Number Generator).

## Pruebas Automáticas

El proyecto posee una amplia cobertura de validación a través de **16 pruebas unitarias y de widgets**.

Para correr la suite de pruebas localmente:
```bash
flutter test
```

## Requisitos y Configuración Inicial

Para ejecutar la aplicación, debes tener el **SDK de Flutter** instalado con soporte para Windows Desktop activado.

### Instalación
```bash
# 1. Clonar este repositorio (si aplicara)
git clone <tu-repositorio>

# 2. Obtener dependencias de pub.dev
flutter pub get

# 3. Ejecutar en Windows
flutter run -d windows
```

---
*Este proyecto fue generado orquestando un ciclo de trabajo agente-asistido.*
