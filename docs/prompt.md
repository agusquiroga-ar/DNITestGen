## El pedido

Como anailsta functional debes entender y definir como debe funcionar una aplicion que tiene por objetivo generar aleatoriamente codigos QR y debarras de documentos nacionales de identidad.

### Resultado

El resultado de tu analisis debe ser un documento en formato markdown que defina las funcionalides que debe tener la aplicacion. Un documento funcional.

### Objetivo de la aplicacion

Generar de forma aleatoria los codigos de barras y qr que tienen los documentos nacionales de identidad argentinos (DNI). En argentina hoy dos tipos de documentos (los nuevos y los viejos), los nuevos poseen un codigo QR, los viejos un codigo de barras.

La aplicacion debe tener un boton que permita generar aleatoriamente estos codigos, cada vez que se presiona el boton se genera uno de estos y mostrarlo en pantalla.

### Especificacion de los codigos

En argentina hoy dos tipos de documentos (los nuevos y los viejos), los nuevos poseen un codigo QR, los viejos un codigo de barras.

En este documento tienes la especificacion de [new_dni_spec.md](file;file:///c%3A/dev/DNITestGen/docs/new_dni_spec.md) como generar el codigo de barras que contiene el DNI version vieja.

En este documento esta la especificacion de como se genera el codigo QR de la nueva version de los documentos [dni_qr_pdf417_spec.md](file;file:///c%3A/dev/DNITestGen/docs/dni_qr_pdf417_spec.md)

### Pantalla de inicio de la aplicacion

Debe poseer un boton "Generar" que al presionarlo genere un codigo aleatorio. Debajo del boton se debe ver una seccion de parametria para configurar como se va a generar el boton.

La parametria debe permir configurar:

- El tipo de DNI a generar: version vieja, version nueva o aleatorio (cualquiera de los dos)
- El rango del numero de documento (minimo y maximo)

### Consideraciones

1. Los nombres y apellidos se tienen que tomar de un diccionario de datos, que contiene la aplicacion en formato JSON. Uno para nombres y otro para apellidos.
2. La aplicacion tiene debe construirse con Flutter
3. La aplicacion debe correr en windows
