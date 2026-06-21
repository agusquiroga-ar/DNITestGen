# Feature 01: Base Application Configuration

## Description
Create the base structure of the Flutter application with Windows support. Implement the main screen with a "Generate" button and a display area (placeholder) where the codes will be shown in the future. Establish the state management pattern (e.g., Provider, Riverpod, or BLoC).

## Acceptance Criteria
1. The application must compile and run successfully on Windows (`flutter run -d windows`).
2. The main screen must contain a title "DNI Generator" (Generador de DNI).
3. There must be a button labeled "Generate" (Generar).
4. There must be a container below the button acting as a placeholder (empty display area).
5. A basic state management system must be integrated, prepared for the upcoming features.

## Required Tests
- **Unit Test:** Verify that the initial state of the application loads correctly.
- **Widget Test:**
  - Verify the existence of the text "DNI Generator".
  - Verify the existence of the "Generate" button.
  - Simulate a tap on the "Generate" button and ensure it does not produce errors.
- **Integration Test:** Verify that the app starts correctly in the Windows environment without exceptions.
