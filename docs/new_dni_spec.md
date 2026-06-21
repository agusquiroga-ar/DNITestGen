# Functional Specification: QR Code in the New Argentine DNI (eDNI)

This document details the technical and functional specification for the generation and processing of the QR code incorporated in the new version of the Electronic National Identity Document (eDNI) of the Argentine Republic, implemented under **Disposition 1255/2023** of the National Registry of Persons (Renaper).

The purpose of this document is to serve as a reference guide for the development of identity simulation, generation, and validation systems.

---

## 1. QR Code Payload (URL Structure)

The new eDNI QR code directly encodes a **secure uniform resource locator (HTTPS URL)** managed and authenticated by the official Renaper domain.

### URL Format

The parameterized URL follows the following structure:

```text
https://mitramite.renaper.gob.ar/validar?id=PROCEDURE_ID&dni=DNI_NUM&sexo=GENDER_CHAR&ejemplar=COPY_CHAR
```

### Payload Parameters Table

| Parameter | Functional Name    | Data Type     | Format / Restrictions      | Description                                                                                                                                                                                                                                |
| :-------- | :----------------- | :------------ | :------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`      | Procedure Number   | Numeric       | Exactly **9 digits**       | Unique issuance identifier. In the eDNI, it has been optimized by reducing the length from the traditional 11 digits to 9 digits to speed up response times. It changes randomly with each renewal of the physical document.             |
| `dni`     | ID Number          | Numeric       | String of **7 or 8 digits**| The cardholder's DNI number, without thousands separators (periods).                                                                                                                                                                       |
| `sexo`    | Gender             | Alphabetic    | 1 character (`M`, `F`, `X`)| Registered gender identifier (`M` = Male, `F` = Female, `X` = Non-Binary under the Gender Identity Law 26.743).                                                                                                                            |
| `ejemplar`| Copy Letter        | Alphanumeric  | 1 or 2 uppercase letters   | Unique identifier of the physical print run or physical version delivered (e.g., `A`, `B`, `C`, `AA`, etc.).                                                                                                                               |

#### Full Payload URL Example:

```text
https://mitramite.renaper.gob.ar/validar?id=102938475&dni=45091283&sexo=X&ejemplar=A
```

---

## 2. Parameterization of the Generation Graphics Engine (QR)

For the simulation and programmatic generation of the QR code, the international standard **ISO/IEC 18004** must be strictly met. Below are the configurations for QR code generator libraries (e.g., `qrcode` in Node.js or equivalents):

* **Error Correction Level (ECC):** **`M`** (Medium Level), which allows the recovery of up to 15% physical damage in the printed area of the code.
* **Quiet Zone (Margin):** **4 logical modules** of minimum margin to avoid failures or interference when performing optical reading.
* **Scale:** **4 pixels** per module of minimum physical density.
* **Colors:** Maximum optical contrast:
  * Dark modules: `#000000` (Absolute black).
  * Background (Light): `#FFFFFF` (Absolute white).

---

## 3. Reference Code Implementation

Below are reference implementations in JavaScript and Python to build the QR URL and validate the parameters of the new electronic DNI.

### JavaScript / TypeScript Implementation

```javascript
/**
 * Builds the parameterized DNI validation URL.
 * @param {object} params - DNI parameters.
 * @param {string|number} params.id - Procedure number (9 digits).
 * @param {string|number} params.dni - ID number (7-8 digits).
 * @param {string} params.sexo - Gender ('M', 'F', 'X').
 * @param {string} params.ejemplar - Copy letter (e.g., 'A').
 * @returns {string} Formatted URL.
 */
function generarUrlQrDni(params) {
  const idStr = params.id.toString().trim();
  const dniStr = params.dni.toString().trim().replace(/\D/g, '');
  const sexoStr = params.sexo.trim().toUpperCase();
  const ejemplarStr = params.ejemplar.trim().toUpperCase();
  
  if (idStr.length !== 9 || isNaN(params.id)) {
    throw new Error("The procedure number (id) for the new electronic DNI must be exactly 9 digits.");
  }
  
  return `https://mitramite.renaper.gob.ar/validar?id=${idStr}&dni=${dniStr}&sexo=${sexoStr}&ejemplar=${ejemplarStr}`;
}
```

### Python Implementation

```python
import re

def generar_url_qr_dni(tramite_id: str, dni: str, sexo: str, ejemplar: str) -> str:
    """
    Builds the official parameterized validation URL for the eDNI QR code.
    """
  
    id_str = str(tramite_id).strip()
    dni_str = re.sub(r"\D", "", str(dni))
    sexo_str = str(sexo).strip().upper()
    ejemplar_str = str(ejemplar).strip().upper()
  
    if len(id_str) != 9 or not id_str.isdigit():
        raise ValueError("The procedure number (id) for the new electronic DNI must be exactly 9 numeric digits.")
  
    return f"https://mitramite.renaper.gob.ar/validar?id={id_str}&dni={dni_str}&sexo={sexo_str}&ejemplar={ejemplar_str}"
```

---

## 4. Validation and Integration Considerations

When integrating the capture of optical codes into computer systems (e.g., KYC flows and digital onboarding), the following business rules must be implemented:

1. **Identity Management with Gender "X":**

   * The receiving databases must allow the storage of the character `X` in the sex/gender column with at least 1 character in length.
   * Legacy validations of the type `if (sexo != 'M' && sexo != 'F')` must be refactored to prevent automatic rejections of valid transactions from people with non-binary gender.
2. **Normalization of Names and Surnames:**

   * When parsing or simulating complementary biographical data, support for the **ISO-8859-1** or **UTF-8** character set must be ensured to avoid the loss of accents or specific characters of the Spanish language (such as the letter **Ñ**).
