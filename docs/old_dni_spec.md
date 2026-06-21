# Code Formats Specification in Old Argentine DNI

This document details the technical specifications of the two-dimensional codes present in the different variants of the old National Identity Document (DNI) of the Argentine Republic, including its data structure, fields, and normalization examples for developers.

---

## 1. Physical Two-Dimensional Barcode (PDF417)

Although commonly referred to as a "QR code", the back of most physical DNI cards in force (issued since 2012) uses **PDF417** stacked two-dimensional barcode technology.

### Scanned String Format

When scanning the PDF417 code using optical readers (in keyboard emulation mode) or through image processing, an ASCII character string delimited by the `@` character is obtained.

### Field Structure (Standard Indices)

When splitting the resulting string using `@` (`split('@')`), an array is obtained whose indices contain the following information:

| Index | Field                     | Format                            | Description                                                  |
| :---- | :------------------------ | :-------------------------------- | :----------------------------------------------------------- |
| **0** | Procedure Number          | Numeric (9 or 11 digits)          | Unique identifier of the physical document issuance.         |
| **1** | Surnames                  | Uppercase text                    | Cardholder's surnames.                                       |
| **2** | Names                     | Uppercase text                    | Cardholder's names.                                          |
| **3** | Gender                    | Character (`M`, `F`, `X`)         | Registered gender.                                           |
| **4** | DNI                       | Numeric (7 or 8 digits)           | ID number (without periods).                                 |
| **5** | Copy Letter               | Character (`A`, `B`, `C`, etc.)   | Version/copy of the document.                                |
| **6** | Date of Birth             | `DD/MM/YYYY`                      | Cardholder's date of birth.                                  |
| **7** | Date of Issue             | `DD/MM/YYYY`                      | Date the copy was issued.                                    |
| **8** | Control Code / CUIL       | Numeric / Variable                | Internal information or identifying fragment of the CUIL.    |

#### Raw String Example:

```text
00112233445@PEREZ@JUAN CARLOS@M@30123456@A@25/12/1985@15/10/2020@200
```

---

## 2. Data Reading and Normalization

Below are examples in JavaScript and Python to parse and normalize the PDF417 code string.

### JavaScript / TypeScript Implementation

```javascript
/**
 * Parses and normalizes the text string of an Argentine DNI (PDF417).
 * @param {string} rawText - Decoded text string from the barcode.
 * @returns {object|null} Object with normalized DNI data or null.
 */
function parsearDniPdf417(rawText) {
  if (!rawText) return null;
  
  const fields = rawText.trim().split('@');
  
  if (fields.length < 8) {
    throw new Error("The format of the scanned text does not match the Argentine DNI standard.");
  }
  
  // Converts DD/MM/YYYY to standard ISO YYYY-MM-DD format
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
    dni: parseInt(fields[4].trim(), 10).toString(), // Removes unnecessary leading zeros
    ejemplar: fields[5].trim().toUpperCase(),
    fechaNacimiento: parseFecha(fields[6].trim()),
    fechaEmision: parseFecha(fields[7].trim()),
  };
}
```

### Python Implementation

```python
from datetime import datetime
from typing import Optional, Dict

def parsear_dni_pdf417(raw_text: str) -> Optional[Dict[str, str]]:
    """
    Parses and normalizes the text string of an Argentine DNI (PDF417).
    """
    if not raw_text:
        return None
      
    fields = [field.strip() for field in raw_text.strip().split('@')]
  
    if len(fields) < 8:
        raise ValueError("The format of the scanned text does not match the Argentine DNI standard.")
      
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
        "dni": str(int(fields[4])),  # Cleans leading zeros
        "ejemplar": fields[5].upper(),
        "fecha_nacimiento": parse_fecha(fields[6]),
        "fecha_emision": parse_fecha(fields[7])
    }
```

> [!WARNING]
> **Encoding Consideration:** When decoding the barcode from the camera or reader, be sure to decode in **UTF-8** or **ISO-8859-1** so as not to break characters specific to Spanish, such as the letter **Ñ** or accented letters (for example: `MUÑOZ` or `MARÍA`).

---

## 3. Dynamic QR Codes (Digital DNI in "Mi Argentina")

The virtual DNI deployed in the "Mi Argentina" mobile app generates a dynamic QR code for security reasons.

* **Data Format:** Stores a **JSON Web Token (JWT)** digitally signed using asymmetric cryptography by the Secretariat of Public Innovation / RENAPER.
* **Reading:** **It is not decodable offline in plain text.** To validate the credential, the official control application called **ValidAR** must be used (which contains the public key to verify the validity of the digital signature) or integrate the service provided through the official State APIs.

---

## 4. Polycarbonate Electronic DNI (Chip and QR)

The new physical DNI model (implemented by RENAPER in late 2023) incorporates polycarbonate, a contactless electronic chip (NFC), and a security QR code.

* **Standard:** Complies with the international **ICAO 9303** standard for travel documents.
* **Data Format:** Both the chip and the associated QR code store biometric and biographical data protected by cryptographic mechanisms to prevent counterfeiting or unauthorized reading.
* **Reading:** Decoding requires cryptographic keys and approved verification systems (for example, through the official **eRENAPER** application).
