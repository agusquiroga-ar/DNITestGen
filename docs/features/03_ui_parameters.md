# Feature 03: User Interface Parameters

## Description
Add a configuration section on the main screen, located below the "Generate" button. These parameters will allow the user to define what type of document they want to generate (Old Version, New Version, Random) and set the numerical range (min and max) for the generated DNI.

## Acceptance Criteria
1. Implement a selector (dropdown or radio buttons) with three options: "Old Version", "New Version", and "Random".
2. Implement two text input fields (TextFormField) for "Minimum DNI" and "Maximum DNI".
3. Validate that the minimum and maximum fields only accept integers.
4. Validate that the minimum value is not greater than the maximum.
5. Connect these parameters with the global state so they are available when the "Generate" button is pressed.

## Required Tests
- **Widget Tests:**
  - Verify that the DNI type selectors exist on the screen.
  - Check that the numeric fields exist and restrict input to digits only.
  - Simulate filling the minimum and maximum fields and verify validation (e.g., min > max throws a UI error).
- **Integration Test:** Verify that changing the parameters in the UI updates the application state with the correct values.
