# Feature 02: Data Models and Random Generator

## Description
Implement the logic to read and process data dictionaries in JSON format for names and surnames. Create a service capable of randomly generating a fictitious data set (name, surname, date of birth, gender, procedure number, copy letter) and a DNI number within a specified range.

## Acceptance Criteria
1. Two JSON files must exist in `assets/` (or generated in memory/mock) containing lists of names and surnames.
2. The system must be able to read and deserialize the JSON files upon startup.
3. Create a `DataGeneratorService` service that provides the function to generate a random "Identity".
4. DNI generation must accept a minimum and maximum value as parameters.
5. The gender must be randomly selected among 'M', 'F', or 'X'.
6. The copy letter (ejemplar) must be randomly generated (e.g., 'A', 'B', 'C').
7. The procedure number (número de trámite) must be exactly 9 digits long.

## Required Tests
- **Unit Tests:**
  - Validate that parsing the JSONs returns non-empty lists.
  - Ensure the random generation function returns names and surnames belonging to the JSON.
  - Validate that the generated DNI respects the input minimum and maximum limits.
  - Check that fields like `sexo` (gender) and `ejemplar` (copy letter) are generated with allowed values.
  - Verify that the generated procedure number is exactly 9 digits long.
