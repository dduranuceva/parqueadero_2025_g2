class Establecimiento {
  /// Este modelo representa un establecimiento y sus atributos.
  final int id;
  final String nombre;
  final String nit;
  final String direccion;
  final String telefono;
  final String logo;
  final String estado;
  // inicializacion de variables
  Establecimiento({
    required this.id,
    required this.nombre,
    required this.nit,
    required this.direccion,
    required this.telefono,
    required this.logo,
    required this.estado,
  });

  //! metodo para convertir un json a un objeto Establecimiento
  /// Convierte un mapa JSON en un objeto Establecimiento.
  factory Establecimiento.fromJson(Map<String, dynamic> json) {
    return Establecimiento(
      id: json['id'],
      nombre: json['nombre'],
      nit: json['nit'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      logo: json['logo'],
      estado: json['estado'],
    );
  }

  //! metodo para convertir un objeto Establecimiento a un json
  /// Convierte un objeto Establecimiento en un mapa JSON.
  Map<String, String> toJson({String? logoBase64}) {
    return {
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'telefono': telefono,
      if (logoBase64 != null) 'logo': logoBase64,
    };
  }
}
