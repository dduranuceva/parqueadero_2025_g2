/// Modelo para representar un Pokemon con su nombre, imagen y tipos
class Pokemon {
  int id;
  String name;
  String image;
  List<String> types;

  // Constructor de la clase Pokemon con los atributos requeridos
  // esto se hace para que al crear una instancia de Pokemon, estos atributos sean obligatorios
  //se usa en el fromJson que es un metodo que convierte un JSON en una instancia de Pokemon
  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
  });

  // Factory porque es un método que retorna una nueva instancia de la clase
  // este metodo se usa para convertir un JSON en una instancia de Pokemon
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      image: json['sprites']['front_default'],
      //en types se guarda la lista de tipos del pokemon.
      // se usa List<String>.from para convertir la lista de tipos del JSON en una lista de Strings en Dart
      types: List<String>.from(json['types'].map((tp) => tp['type']['name'])),
    );
  }
}
