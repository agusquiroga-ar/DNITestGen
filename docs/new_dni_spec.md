# Especificación Funcional: Código QR en el Nuevo DNI Argentino (eDNI)

Este documento detalla la especificación técnica y funcional para la generación y el procesamiento del código QR incorporado en la nueva versión del Documento Nacional de Identidad Electrónico (eDNI) de la República Argentina, implementado bajo la **Disposición 1255/2023** del Registro Nacional de las Personas (Renaper).

El propósito de este documento es servir como guía de referencia para el desarrollo de sistemas de simulación, generación y validación de identidades.

---

## 1. Payload del Código QR (Estructura de la URL)

El código QR del nuevo eDNI codifica directamente una **dirección web uniforme de recurso segura (URL HTTPS)** administrada y autenticada por el dominio oficial del Renaper.

### Formato de la URL

La URL parametrizada sigue la siguiente estructura:

```text
https://mitramite.renaper.gob.ar/validar?id=TRAMITE_ID&dni=DNI_NUM&sexo=GEN_CHAR&ejemplar=EJ_CHAR
```

### Tabla de Parámetros del Payload


| Parámetro | Nombre Funcional    | Tipo de Dato  | Formato / Restricciones      | Descripción                                                                                                                                                                                                                                |
| :----------- | :-------------------- | :-------------- | :----------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`       | Número de Trámite | Numérico     | Exactamente**9 dígitos**    | Identificador único de emisión. En el eDNI se ha optimizado reduciendo la longitud de los 11 dígitos tradicionales a 9 dígitos para acelerar los tiempos de respuesta. Cambia aleatoriamente en cada renovación del documento físico. |
| `dni`      | Matrícula          | Numérico     | Cadena de **7 u 8 dígitos** | Número del DNI del titular, sin puntos de separación de millares.                                                                                                                                                                         |
| `sexo`     | Género             | Alfabético   | 1 carácter (`M`, `F`, `X`)  | Identificador del sexo registrado (`M` = Masculino, `F` = Femenino, `X` = No Binario bajo la Ley 26.743 de Identidad de Género).                                                                                                           |
| `ejemplar` | Ejemplar            | Alfanumérico | 1 o 2 letras en mayúsculas  | Identificador único de la tirada física o versión física entregada (ej.:`A`, `B`, `C`, `AA`, etc.).                                                                                                                                     |

#### Ejemplo de URL de Payload Completa:

```text
https://mitramite.renaper.gob.ar/validar?id=102938475&dni=45091283&sexo=X&ejemplar=A
```

---

## 2. Parametrización del Motor Gráfico de Generación (QR)

Para la simulación y generación programática del código QR, se debe cumplir de forma estricta con el estándar internacional **ISO/IEC 18004**. A continuación se detallan las configuraciones para las librerías generadoras de códigos QR (ej. `qrcode` en Node.js o equivalentes):

* **Nivel de Corrección de Errores (ECC):** **`M`** (Nivel Medio), el cual permite la recuperación de hasta el 15% de daño físico en el área impresa del código.
* **Zona de Silencio (Margin):** **4 módulos lógicos** de margen mínimo para evitar fallas o interferencias al realizar la lectura óptica.
* **Escala (Scale):** **4 píxeles** por módulo de densidad física mínima.
* **Colores:** Contraste óptico máximo:
  * Módulos oscuros (Dark): `#000000` (Negro absoluto).
  * Fondo (Light): `#FFFFFF` (Blanco absoluto).

---

## 3. Implementación de Referencia en Código

A continuación se dejan implementaciones de referencia en JavaScript y Python para construir la URL del QR y validar los parámetros del nuevo DNI electrónico.

### Implementación en JavaScript / TypeScript

```javascript
/**
 * Construye la URL de validación parametrizada del DNI.
 * @param {object} params - Parámetros del DNI.
 * @param {string|number} params.id - Número de trámite (9 dígitos).
 * @param {string|number} params.dni - Matrícula (7-8 dígitos).
 * @param {string} params.sexo - Género ('M', 'F', 'X').
 * @param {string} params.ejemplar - Letra del ejemplar (ej. 'A').
 * @returns {string} URL formateada.
 */
function generarUrlQrDni(params) {
  const idStr = params.id.toString().trim();
  const dniStr = params.dni.toString().trim().replace(/\D/g, '');
  const sexoStr = params.sexo.trim().toUpperCase();
  const ejemplarStr = params.ejemplar.trim().toUpperCase();
  
  if (idStr.length !== 9 || isNaN(params.id)) {
    throw new Error("El número de trámite (id) para el nuevo DNI electrónico debe ser exactamente de 9 dígitos.");
  }
  
  return `https://mitramite.renaper.gob.ar/validar?id=${idStr}&dni=${dniStr}&sexo=${sexoStr}&ejemplar=${ejemplarStr}`;
}
```

### Implementación en Python

```python
import re

def generar_url_qr_dni(tramite_id: str, dni: str, sexo: str, ejemplar: str) -> str:
    """
    Construye la URL de validación oficial parametrizada para el código QR del eDNI.
    """
  
    id_str = str(tramite_id).strip()
    dni_str = re.sub(r"\D", "", str(dni))
    sexo_str = str(sexo).strip().upper()
    ejemplar_str = str(ejemplar).strip().upper()
  
    if len(id_str) != 9 or not id_str.isdigit():
        raise ValueError("El número de trámite (id) para el nuevo DNI electrónico debe ser exactamente de 9 dígitos numéricos.")
  
    return f"https://mitramite.renaper.gob.ar/validar?id={id_str}&dni={dni_str}&sexo={sexo_str}&ejemplar={ejemplar_str}"
```

---

## 4. Consideraciones de Validación e Integración

Al integrar la captura de los códigos ópticos en sistemas informáticos (por ejemplo, flujos KYC y onboarding digital), se deben implementar las siguientes reglas de negocio:

1. **Gestión de Identidades con Género "X":**

   * Las bases de datos receptoras deben permitir el almacenamiento del carácter `X` en la columna de sexo/género con al menos 1 carácter de longitud.
   * Se deben refactorizar validaciones legadas del tipo `if (sexo != 'M' && sexo != 'F')` para prevenir rechazos automáticos de transacciones válidas de personas con género no binario.
2. **Normalización de Nombres y Apellidos:**

   * Al parsear o simular datos biográficos complementarios, se debe asegurar el soporte para el set de caracteres **ISO-8859-1** o **UTF-8** para evitar la pérdida de tildes o caracteres específicos del idioma español (como la letra **Ñ**).
