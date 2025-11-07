class Categoria {
  int? id;
  String nombre;
  String descripcion;

  Categoria({this.id, required this.nombre, required this.descripcion});

  /// Convierte un mapa (registro de la base de datos) a una instancia de Categoria
  factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
  );

  /// Convierte la instancia de Categoria a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
  };
}
