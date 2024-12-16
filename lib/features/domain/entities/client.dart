class Client {
  final int id;
  final String numeroDocumento;
  final String razonSocial;
  final String nombreComercial;
  final String celular;
  final String direccion;
  final String imagen;
  final String tipoDocumento;
  final int ubigeo;
  final int codigoPais;

  Client({
    required this.id,
    required this.numeroDocumento,
    required this.razonSocial,
    required this.nombreComercial,
    required this.celular,
    required this.direccion,
    required this.imagen,
    required this.tipoDocumento,
    required this.ubigeo,
    required this.codigoPais,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      numeroDocumento: int.parse(json['numeroDocumento']).toString(),
      razonSocial: json['razonSocial'],
      nombreComercial: json['nombreComercial'],
      celular: json['celular'],
      direccion: json['direccion'],
      imagen: json['imagen'],
      tipoDocumento: int.parse(json['tipoDocumento']).toString(),
      ubigeo: json['ubigeo'],
      codigoPais: json['codigoPais'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroDocumento': numeroDocumento,
      'razonSocial': razonSocial,
      'nombreComercial': nombreComercial,
      'celular': celular,
      'direccion': direccion,
      'imagen': imagen,
      'tipoDocumento': tipoDocumento,
      'ubigeo': ubigeo,
      'codigoPais': codigoPais,
    };
  }
}
