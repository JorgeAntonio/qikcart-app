class CreateClient {
  final String numeroDocumento;
  final String razonSocial;
  final String nombreComercial;
  final String direccion;
  final String? celular;
  final String? imagen;
  final int tipoDocumento;
  final int ubigeo;
  final int codigoPais;

  CreateClient({
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

  // Convertir la clase CreateClient en un mapa para enviarlo a una API o guardarlo
  Map<String, dynamic> toJson() {
    return {
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
