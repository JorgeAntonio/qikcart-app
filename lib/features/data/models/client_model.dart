class ClientModel {
  final int id;
  final String numeroDocumento;
  final String razonSocial;
  final String nombreComercial;
  final String celular;
  final String direccion;
  final String imagen;
  final int tipoDocumento;
  final int ubigeo;
  final int codigoPais;

  ClientModel({
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

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      numeroDocumento: json['numeroDocumento'],
      razonSocial: json['razonSocial'],
      nombreComercial: json['nombreComercial'],
      celular: json['celular'],
      direccion: json['direccion'],
      imagen: json['imagen'],
      tipoDocumento: json['tipoDocumento'],
      ubigeo: json['ubigeo'],
      codigoPais: json['codigoPais'],
    );
  }
}
