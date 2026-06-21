# Feature 07: Generated Codes Directory

## Description
Add a side panel to the main screen that acts as a directory/history of all the DNI codes generated during the current session. The system must store the generated identities in memory and allow the user to select any previous generation from the list to display its code and biographical data again. Additionally, the feature must include functionality to persist (save) and recover (load) the session state to/from a local JSON file, allowing the user to continue working with a previously saved set of generated codes and append new ones.

## Acceptance Criteria
1. **In-Memory History:** Every time the "Generate" button is pressed, the newly created identity and its specific format type (Old PDF417 or New QR) must be appended to an in-memory list managed by the global state.
2. **Side Panel UI:** The main screen must include a side panel (e.g., using a `Row` layout or a `Drawer`) displaying a list of generated codes. Each list item should show a brief summary (e.g., DNI number, Surname, and Format Type).
3. **History Selection:** Clicking an item in the side panel list must update the main display area to show the selected DNI's graphical code and biographical data, without generating a new one.
4. **Save Session:** The side panel must contain a "Save Session" button that serializes the in-memory list of generated identities and their formats to a local JSON file chosen by the user (e.g., using a file picker dialog).
5. **Load Session:** The side panel must contain a "Load Session" button that allows the user to select and deserialize a previously saved JSON file. This action should populate the in-memory list and update the side panel accordingly.
6. **Continuous Generation:** After loading a session, the user must be able to continue generating new codes. These new codes will be appended to the loaded list, and the user must be able to save the updated session again.

## Required Tests
- **Unit Tests:**
  - Verify that the `Identity` model and generation history can be successfully serialized to JSON (e.g., `toJson()` / `fromJson()`).
  - Verify that the state manager correctly appends new identities to the history list without losing previous entries.
- **Widget Tests:**
  - Ensure the side panel renders the list of generated items correctly as the state updates.
  - Verify that tapping an item in the history list updates the active main display state.
  - Verify the presence of the "Save Session" and "Load Session" buttons in the UI.
- **Integration Test:**
  - Simulate a complete workflow: generate a code, save the session to a mock file, load the session back, verify the item appears in the side panel, click it to render it, generate a second code, and verify both exist in the history list.
