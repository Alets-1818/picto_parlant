class Pictograma {
  final String nombre;
  final String imagen;
  final String? categoria; // ← Añadido este campo opcional

  Pictograma({
    required this.nombre,
    required this.imagen,
    this.categoria, // ← Añadido al constructor
  });

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'imagen': imagen, 'categoria': categoria};
  }

  factory Pictograma.fromJson(Map<String, dynamic> json) {
    return Pictograma(
      nombre: json['nombre'],
      imagen: json['imagen'],
      categoria: json['categoria'],
    );
  }
}
