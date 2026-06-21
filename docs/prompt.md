## The Request

As a functional analyst, you must understand and define how an application should work whose goal is to randomly generate QR codes and barcodes for national identity documents.

### Result

The result of your analysis must be a markdown document that defines the functionalities the application must have. A functional document.

### Application Goal

Randomly generate the barcodes and QR codes found on the Argentine National Identity Documents (DNI). In Argentina today there are two types of documents (the new ones and the old ones), the new ones have a QR code, the old ones have a barcode.

The application must have a button that allows randomly generating these codes, each time the button is pressed one of these is generated and displayed on the screen.

### Code Specification

In Argentina today there are two types of documents (the new ones and the old ones), the new ones have a QR code, the old ones have a barcode.

In this document you have the specification of [old_dni_spec.md](file:///c:/dev/DNITestGen/docs/old_dni_spec.md) on how to generate the barcode that contains the old version DNI.

In this document is the specification of how the QR code of the new version of the documents is generated [new_dni_spec.md](file:///c:/dev/DNITestGen/docs/new_dni_spec.md)

### Application Home Screen

It must have a "Generate" button that, when pressed, generates a random code. Below the button, there must be a parameterization section to configure how the generation will behave.

The parameterization must allow configuring:

- The type of DNI to generate: old version, new version, or random (either of the two)
- The document number range (minimum and maximum)

### Considerations

1. Names and surnames must be taken from a data dictionary, which the application contains in JSON format. One for names and another for surnames.
2. The application must be built with Flutter
3. The application must run on Windows
