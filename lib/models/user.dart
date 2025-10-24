class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  //* convierte un objeto JSON a un objeto User
  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], email: json['email']);

  //* convierte un objeto User a un objeto JSON
  //* se usa para enviar el objeto User al servidor
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
