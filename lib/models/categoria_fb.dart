class CategoriaFb {
  final String id;
  final String nombre;
  final String descripcion;

  CategoriaFb({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory CategoriaFb.fromMap(String id, Map<String, dynamic> data) {
    return CategoriaFb(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'descripcion': descripcion};
  }
}
