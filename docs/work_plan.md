# Work Plan - DNI Test Gen (Identity and DNI Code Generator)

## Project Description
The project consists of a desktop application developed in Flutter for Windows, whose main objective is to randomly generate test credentials similar to the Argentine National Identity Document.
The application supports the generation of codes for the old version (PDF417) and the new version (eDNI QR).

## Methodology
The development will follow an incremental approach ("Spec Driven Development"), where functionality grows as each new functional requirement (feature) is integrated. The tasks have been sequenced to avoid blockers and minimize dependencies.

## Work Index and Features

| Order | Feature | Specification File | Previous Dependencies | Complexity |
| :---: | :--- | :--- | :--- | :--- |
| **1** | **Base Application Configuration** | [01_base_application.md](file:///c:/dev/DNITestGen/docs/features/01_base_application.md) | None | Low |
| **2** | **Data Models and Random Generator** | [02_data_models.md](file:///c:/dev/DNITestGen/docs/features/02_data_models.md) | Feature 1 | Medium-Low |
| **3** | **User Interface Parameters** | [03_ui_parameters.md](file:///c:/dev/DNITestGen/docs/features/03_ui_parameters.md) | Feature 1 | Low |
| **4** | **Old DNI Version Generator (PDF417)** | [04_old_dni_generator.md](file:///c:/dev/DNITestGen/docs/features/04_old_dni_generator.md) | Feature 2 | Medium |
| **5** | **New eDNI Generator (QR)** | [05_new_dni_generator.md](file:///c:/dev/DNITestGen/docs/features/05_new_dni_generator.md) | Feature 2 | Medium |
| **6** | **Final Integration and Generation Logic** | [06_generator_integration.md](file:///c:/dev/DNITestGen/docs/features/06_generator_integration.md) | Features 3, 4, and 5 | High |

### Justification of the Implementation Order
1. **Feature 1** prepares the basic "shell" without heavy logic to avoid blocking the rest.
2. **Feature 2** provides the essential data engine. Without random data, nothing can be graphed.
3. **Feature 3** adds UI parameterization in parallel without depending directly on the graphics engine.
4. **Features 4 and 5** are the drawing engines for each type of code. They can be developed independently once the data models exist (Feature 2).
5. **Feature 6** unites the entire project: connects the UI parameters and buttons with the generation of random identities and the respective graphic (PDF417 or QR).

## Instructions for the Implementer Agent
Read sequentially each of the referenced files in this plan. Validate the "Acceptance Criteria" and build the recommended tests in the "Required Tests" section before considering the feature finished.
