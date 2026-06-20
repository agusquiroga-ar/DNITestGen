# Especificación de Formatos de Códigos en antiguo DNI Argentino

Este documento detalla las especificaciones técnicas de los códigos bidimensionales presentes en las distintas variantes del antiguo



Documento Nacional de Identidad (DNI) de la República Argentina, incluyendo su estructura de datos, campos y ejemplos de normalización para desarrolladores.

---

## 1. Código de Barras Bidimensional Físico (PDF417)

Aunque comúnmente denominado "código QR", el reverso de la mayoría de las tarjetas físicas de DNI vigentes (emitidas desde el año 2012) utiliza la tecnología de código de barras bidimensional apilado **PDF417**.

### Formato del String Escaneado

Al escanear el código PDF417 utilizando lectores ópticos (en modo emulación de teclado) o mediante procesamiento de imágenes, se obtiene una cadena de caracteres ASCII delimitada por el carácter `@`.

### Estructura de Campos (Índices Estándar)

Al separar la cadena resultante usando `@` (`split('@')`), se obtiene un arreglo cuyos índices contienen la siguiente información:


| Índice | Campo                     | Formato                         | Descripción                                               |
| :-------- | :-------------------------- | :-------------------------------- | :----------------------------------------------------------- |
| **0**   | Número de Trámite       | Numérico (9 u 11 dígitos)     | Identificador único de la emisión del documento físico. |
| **1**   | Apellidos                 | Texto en mayúsculas            | Apellidos del titular.                                     |
| **2**   | Nombres                   | Texto en mayúsculas            | Nombres del titular.                                       |
| **3**   | Sexo                      | Carácter (`M`, `F`, `X`)       | Género registrado.                                        |
| **4**   | DNI                       | Numérico (7 u 8 dígitos)      | Número de documento (sin puntos).                         |
| **5**   | Ejemplar                  | Carácter (`A`, `B`, `C`, etc.) | Versión/copia del documento.                              |
| **6**   | Fecha de Nacimiento       | `DD/MM/AAAA`                    | Fecha de nacimiento del titular.                           |
| **7**   | Fecha de Emisión         | `DD/MM/AAAA`                    | Fecha en la que se emitió el ejemplar.                    |
| **8**   | Código de Control / CUIL | Numérico / Variable            | Información interna o fragmento identificador del CUIL.   |

#### Ejemplo de Cadena Cruda:

```text
00112233445@PEREZ@JUAN CARLOS@M@30123456@A@25/12/1985@15/10/2020@200
```

---

## 2. Lectura y Normalización de Datos

A continuación se presentan ejemplos en JavaScript y Python para parsear y normalizar la cadena del código PDF417.

### Implementación en JavaScript / TypeScript

```javascript
/**
 * Parsea y normaliza la cadena de texto de un DNI argentino (PDF417).
 * @param {string} rawText - Cadena de texto decodificada del código de barras.
 * @returns {object|null} Objeto con los datos del DNI normalizados o null.
 */
function parsearDniPdf417(rawText) {
  if (!rawText) return null;
  
  const fields = rawText.trim().split('@');
  
  if (fields.length < 8) {
    throw new Error("El formato del texto escaneado no coincide con el estándar del DNI argentino.");
  }
  
  // Convierte DD/MM/AAAA a formato estándar ISO YYYY-MM-DD
  const parseFecha = (fechaStr) => {
    if (!fechaStr) return null;
    const parts = fechaStr.split('/');
    if (parts.length === 3) {
      return `${parts[2]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
    }
    return null;
  };

  return {
    nroTramite: fields[0].trim(),
    apellido: fields[1].trim(),
    nombre: fields[2].trim(),
    sexo: fields[3].trim().toUpperCase(),
    dni: parseInt(fields[4].trim(), 10).toString(), // Remueve ceros a la izquierda innecesarios
    ejemplar: fields[5].trim().toUpperCase(),
    fechaNacimiento: parseFecha(fields[6].trim()),
    fechaEmision: parseFecha(fields[7].trim()),
  };
}
```

### Implementación en Python

```python
from datetime import datetime
from typing import Optional, Dict

def parsear_dni_pdf417(raw_text: str) -> Optional[Dict[str, str]]:
    """
    Parsea y normaliza la cadena de texto de un DNI argentino (PDF417).
    """
    if not raw_text:
        return None
      
    fields = [field.strip() for field in raw_text.strip().split('@')]
  
    if len(fields) < 8:
        raise ValueError("El formato del texto escaneado no coincide con el estándar del DNI argentino.")
      
    def parse_fecha(fecha_str: str) -> Optional[str]:
        try:
            return datetime.strptime(fecha_str, "%d/%m/%Y").strftime("%Y-%m-%d")
        except ValueError:
            return None

    return {
        "nro_tramite": fields[0],
        "apellido": fields[1],
        "nombre": fields[2],
        "sexo": fields[3].upper(),
        "dni": str(int(fields[4])),  # Limpia ceros a la izquierda
        "ejemplar": fields[5].upper(),
        "fecha_nacimiento": parse_fecha(fields[6]),
        "fecha_emision": parse_fecha(fields[7])
    }
```

> [!WARNING]
> **Consideración de codificación (Encoding):** Al decodificar el código de barras desde la cámara o lector, asegúrese de decodificar en **UTF-8** o **ISO-8859-1** para no romper caracteres propios del español, como la letra **Ñ** o letras acentuadas (por ejemplo: `MUÑOZ` o `MARÍA`).

---

## 3. Códigos QR Dinámicos (DNI Digital en "Mi Argentina")

El DNI virtual desplegado en la app móvil "Mi Argentina" genera un código QR dinámico por motivos de seguridad.

* **Formato de datos:** Almacena un **JSON Web Token (JWT)** firmado digitalmente mediante criptografía asimétrica por la Secretaría de Innovación Pública / RENAPER.
* **Lectura:** **No es decodificable offline en texto plano.** Para validar la credencial, se debe utilizar la aplicación oficial de control llamada **ValidAR** (la cual contiene la clave pública para verificar la validez de la firma digital) o integrar el servicio provisto mediante las APIs oficiales del Estado.

---

## 4. DNI Electrónico de Policarbonato (Chip y QR)

El nuevo modelo de DNI físico (implementado por el RENAPER a finales de 2023) incorpora policarbonato, un chip electrónico sin contacto (NFC) y un código QR de seguridad.

* **Estándar:** Cumple con la normativa internacional **ICAO/OACI 9303** para documentos de viaje.
* **Formato de datos:** Tanto el chip como el código QR asociado almacenan datos biométricos y biográficos protegidos por mecanismos criptográficos para impedir la falsificación o lectura no autorizada.
* **Lectura:** La decodificación requiere de claves criptográficas y sistemas homologados de verificación (por ejemplo, mediante la aplicación oficial **eRENAPER**).
