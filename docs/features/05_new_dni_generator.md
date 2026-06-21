# Feature 05: New eDNI Generator (QR)

## Description
Implement the logic to build the parameterized validation URL required for the new electronic DNI. Integrate a library (e.g., `qr_flutter`) to render the QR code in the application, complying with technical specifications (Error correction level M, minimum margin, high contrast).

## Acceptance Criteria
1. Create a function that takes the Identity object and returns a URL with the format: `https://mitramite.renaper.gob.ar/validar?id={id}&dni={dni}&sexo={sexo}&ejemplar={ejemplar}`.
2. Validate that the `id` parameter has exactly 9 digits, and that the DNI has no periods.
3. Display a widget that visually renders the QR corresponding to the generated URL in the display area.
4. Ensure the QR is rendered with Error Correction Level M and with black and white colors.

## Required Tests
- **Unit Test:**
  - Validate that the generated URL contains the identity model parameters correctly injected.
  - Ensure an exception is thrown if the `id` does not have 9 digits.
- **Widget Test:**
  - Check that the QR rendering widget exists in the widget tree when a valid URL is passed and that the configured colors are correct.
