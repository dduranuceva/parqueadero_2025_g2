/// Modelo para representar un CDT (Certificado de Depósito a Término)
class CDT {
  String nombreentidad; // nombre de la entidad financiera
  String descripcion; // descripción del plazo del CDT
  String tasa; // tasa de interés
  String monto; // monto del CDT

  // Constructor de la clase CDT con los atributos requeridos
  // esto se hace para que al crear una instancia de CDT, estos atributos sean obligatorios
  // se usa en el fromJson que es un método que convierte un JSON en una instancia de CDT
  CDT({
    required this.nombreentidad,
    required this.descripcion,
    required this.tasa,
    required this.monto,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este método se usa para convertir un JSON en una instancia de CDT
  factory CDT.fromJson(Map<String, dynamic> json) {
    return CDT(
      nombreentidad: json['nombreentidad'] ?? '',
      descripcion: json['descripcion'] ?? '',
      tasa: json['tasa']?.toString() ?? '0',
      monto: json['monto']?.toString() ?? '0',
    );
  }
}
