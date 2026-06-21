# Feature 04: Old DNI Version Generator (PDF417)

## Description
Implement the logic to build the text string in PDF417 format according to the old DNI specification. Incorporate a library (e.g., `pdf417_barcode` or equivalent) to visually render the two-dimensional barcode in the interface.

## Acceptance Criteria
1. Create a function that takes the Identity object (generated in Feature 02) and returns an `@`-delimited string with the expected format: `ProcedureNum@Surname@Name@Gender@DNI@CopyLetter@BirthDate@IssueDate@Code`.
2. Ensure dates are in `DD/MM/YYYY` format.
3. Ensure surnames and names are uppercase.
4. Display a widget that visually renders the generated string in a PDF417 barcode format in the display area.

## Required Tests
- **Unit Test:**
  - Validate that the returned string contains exactly 9 fields separated by 8 `@` characters.
  - Ensure correct date formatting to `DD/MM/YYYY`.
  - Check that the text data matches the Identity model (uppercase, leading zeros kept, etc.).
- **Widget Test:**
  - Verify that the PDF417 rendering widget exists in the widget tree when a valid string is passed.
