class Identity {
  final String nombre;
  final String apellido;
  final String sexo;
  final int dni;
  final String ejemplar;
  final String tramiteId;
  final DateTime fechaNacimiento;
  final DateTime fechaEmision;

  Identity({
    required this.nombre,
    required this.apellido,
    required this.sexo,
    required this.dni,
    required this.ejemplar,
    required this.tramiteId,
    required this.fechaNacimiento,
    required this.fechaEmision,
  });

  @override
  String toString() {
    return 'Identity(nombre: $nombre, apellido: $apellido, sexo: $sexo, dni: $dni, ejemplar: $ejemplar, tramiteId: $tramiteId)';
  }
}
