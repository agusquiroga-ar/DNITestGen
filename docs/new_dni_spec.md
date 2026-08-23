# Functional Specification: QR Code in the New Argentine DNI (eDNI)

This document details the technical and functional specification for the generation and processing of the QR code incorporated in the new version of the Electronic National Identity Document (eDNI) of the Argentine Republic, implemented under **Disposition 1255/2023** of the National Registry of Persons (Renaper).

The purpose of this document is to serve as a reference guide for the development of identity simulation, generation, and validation systems.

---

## 1. QR Code Payload (Structured String)

The new eDNI QR code directly encodes an ASCII character string delimited by the `@` character, similar to the legacy PDF417 format, but ending with a JSON Web Token (JWT) signature.

### Payload Format

The structured payload follows the following format:

```text
PROCEDURE_ID@LASTNAME@FIRSTNAME@DNI_NUM@COPY_CHAR@BIRTH_DATE@ISSUE_DATE@JWT_SIGNATURE
```

### Payload Parameters Table

| Index | Parameter          | Data Type     | Format / Restrictions      | Description                                                                                                                                                                                                                                |
| :---- | :----------------- | :------------ | :------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **0** | Procedure Number   | Numeric       | Exactly **11 digits**      | Unique issuance identifier padded with zeros. It changes randomly with each renewal of the physical document.             |
| **1** | Lastname           | Uppercase text|                            | The cardholder's surnames.                                                                                                                                                                       |
| **2** | Firstname          | Uppercase text|                            | The cardholder's names.                                                                                                                                                                       |
| **3** | ID Number          | Numeric       | String of **7 or 8 digits**| The cardholder's DNI number, without thousands separators (periods).                                                                                                                                                                       |
| **4** | Copy Letter        | Alphanumeric  | 1 or 2 uppercase letters   | Unique identifier of the physical print run or physical version delivered (e.g., `A`, `B`, `C`, `AA`, etc.).                                                                                                                               |
| **5** | Date of Birth      | Date          | `DD/MM/YY`                 | Cardholder's date of birth in 2-digit year format.                                                                                                                                                                       |
| **6** | Date of Issue      | Date          | `DD/MM/YY`                 | Date the copy was issued in 2-digit year format.                                                                                                                                                                       |
| **7** | JWT Signature      | Base64 Token  | String                     | Cryptographic token (JWT) containing at least the procedure ID without padding in its payload. Verified against official public keys.                                                                                                                                                                       |

#### Full Payload Example:

```text
00746756270@PEREZ@JUAN@45091283@A@29/12/10@18/02/26@eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpZF90cmFtaXRlIjoiNzQ2NzU2MjcwIn0.dummySignature...
```

---

## 2. Parameterization of the Generation Graphics Engine (QR)

For the simulation and programmatic generation of the QR code, the international standard **ISO/IEC 18004** must be strictly met. Below are the configurations for QR code generator libraries (e.g., `qrcode` in Node.js or equivalents):

* **QR Version:** **15** (High density) to fit the larger payload size (~470 bytes).
* **Error Correction Level (ECC):** **`M`** (Medium Level), which allows the recovery of up to 15% physical damage in the printed area of the code.
* **Quiet Zone (Margin):** **4 logical modules** of minimum margin to avoid failures or interference when performing optical reading.
* **Scale:** **4 pixels** per module of minimum physical density.
* **Colors:** Maximum optical contrast:
  * Dark modules: `#000000` (Absolute black).
  * Background (Light): `#FFFFFF` (Absolute white).

---

## 3. Reference Code Implementation

Below are reference implementations in JavaScript and Python to validate the parameters of the new electronic DNI.

### JavaScript / TypeScript Implementation

```javascript
/**
 * Parses the new eDNI QR string.
 * @param {string} rawText - Raw string from QR.
 * @returns {object} Parsed properties.
 */
function parsearNuevoQr(rawText) {
  const fields = rawText.split('@');
  if (fields.length !== 8) {
    throw new Error("Invalid New DNI payload format");
  }
  
  return {
    tramiteId: fields[0],
    apellido: fields[1],
    nombre: fields[2],
    dni: fields[3],
    ejemplar: fields[4],
    fechaNac: fields[5],
    fechaEmi: fields[6],
    jwt: fields[7]
  };
}
```

### Python Implementation

```python
def parse_new_dni_qr(raw_text: str) -> dict:
    """
    Parses the new eDNI QR string.
    """
    fields = raw_text.split('@')
    
    if len(fields) != 8:
        raise ValueError("Invalid New DNI payload format")
        
    return {
        "tramiteId": fields[0],
        "apellido": fields[1],
        "nombre": fields[2],
        "dni": fields[3],
        "ejemplar": fields[4],
        "fechaNac": fields[5],
        "fechaEmi": fields[6],
        "jwt": fields[7]
    }
```
