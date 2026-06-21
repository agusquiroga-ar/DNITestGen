# Feature 06: Final Integration and Generation Logic

## Description
Link all created components: the "Generate" button, the parameters configured in the UI, and the DNI generators. Upon pressing the button, the system must read the parameters, generate a valid identity, and based on the selected DNI type, display the PDF417 (old) or the QR (new) on the screen.

## Acceptance Criteria
1. When clicking "Generate", the system must check the state of the numerical parameters and validate that min <= max.
2. Based on the type selector:
   - If "Old Version", it must generate the identity and show a PDF417.
   - If "New Version", it must generate the identity and show a QR.
   - If "Random", it must internally choose (e.g., with 50% probability) between Old Version and New Version on each press.
3. The display area must dynamically update with the new code and the biographical data in plain text for user reference below the graphic.

## Required Tests
- **Integration Test (End-to-End):**
  - Simulate the full user flow: configure values (min, max, type), press the button, and confirm that a barcode or QR widget appears on the screen along with the texts corresponding to the identity.
  - Repeat the flow selecting "Random" and press the button multiple times, ensuring there are no application crashes.
