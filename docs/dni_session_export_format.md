# DNI Test Gen - Session Export Format Specification

## Overview

The DNI Test Gen application allows users to export their generated DNI session history. The exported file is a standard JSON array (`dni_session.json`) containing a list of all generated DNI records during that session.

This specification describes the JSON schema of the exported file. You can use this format to programmatically generate sessions or inject data into the application.

## JSON Structure

The root of the file is a **JSON Array**. Each element in the array represents a single `GeneratedCodeRecord` object.

### Example Payload

```json
[
  {
    "identity": {
      "nombre": "Juan",
      "apellido": "Pérez",
      "sexo": "M",
      "dni": 35123456,
      "ejemplar": "A",
      "tramiteId": "00205412345",
      "fechaNacimiento": "1990-05-15T00:00:00.000",
      "fechaEmision": "2023-10-01T14:30:00.000"
    },
    "type": "oldVersion",
    "generatedAt": "2023-10-25T16:45:12.345"
  },
  {
    "identity": {
      "nombre": "María",
      "apellido": "Gómez",
      "sexo": "F",
      "dni": 40987654,
      "ejemplar": "B",
      "tramiteId": "00109876543",
      "fechaNacimiento": "1998-11-20T00:00:00.000",
      "fechaEmision": "2024-01-10T09:15:00.000"
    },
    "type": "newVersion",
    "generatedAt": "2024-01-15T10:05:00.000"
  }
]
```

## Schema Details

### Root Array
*   **Type:** `Array<Object>`
*   **Description:** A list of generated DNI records.

### Record Object (`GeneratedCodeRecord`)

| Field | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| `identity` | `Object` | Contains all the biographical and document data. | Yes |
| `type` | `String` | The type of DNI format generated. Valid values: `"oldVersion"` (PDF417) or `"newVersion"` (QR). | Yes |
| `generatedAt` | `String` | ISO-8601 formatted datetime string representing when the record was generated (e.g., `2023-10-25T16:45:12.345`). | Yes |

### Identity Object (`Identity`)

| Field | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| `nombre` | `String` | First name(s). | Yes |
| `apellido` | `String` | Last name(s). | Yes |
| `sexo` | `String` | Gender. Typical values: `"M"` (Male), `"F"` (Female), `"X"` (Non-binary). | Yes |
| `dni` | `Integer` | National Identity Document number (e.g., `35123456`). | Yes |
| `ejemplar` | `String` | Copy letter. Typical values: `"A"`, `"B"`, `"C"`, etc. | Yes |
| `tramiteId` | `String` | 11-digit Procedure Number string (Número de Trámite). | Yes |
| `fechaNacimiento` | `String` | ISO-8601 formatted datetime string for Date of Birth. | Yes |
| `fechaEmision` | `String` | ISO-8601 formatted datetime string for Date of Issue. | Yes |

## Usage for Agents

If you are an agent tasked with generating a mock `dni_session.json` file for testing:
1. Ensure the root is an array `[]`.
2. Generate valid mock data for the `Identity` properties. Make sure `dni` is an integer, and `tramiteId` is an 11-digit string.
3. Use strict ISO-8601 formatting for all date fields (`fechaNacimiento`, `fechaEmision`, `generatedAt`).
4. Set the `type` precisely to either `"oldVersion"` or `"newVersion"`.
