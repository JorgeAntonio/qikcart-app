class Comprobante {
  final int? id;
  final String serie;
  final String numeroComprobante;
  final String? fechaEmision;
  final bool emitidoASunat;
  final int emisor;
  final int adquiriente;
  final String tipoComprobante;
  final String tipoOperacion;
  final int tipoPago;
  final String? resumenDeEmision;
  final int codigoMoneda;
  final String? estado;

  const Comprobante({
    this.id,
    required this.serie,
    required this.numeroComprobante,
    this.fechaEmision,
    required this.emitidoASunat,
    required this.emisor,
    required this.adquiriente,
    required this.tipoComprobante,
    required this.tipoOperacion,
    required this.tipoPago,
    this.resumenDeEmision,
    required this.codigoMoneda,
    this.estado,
  });

  factory Comprobante.fromJson(Map<String, dynamic> json) {
    return Comprobante(
      id: json['id'],
      serie: json['serie'],
      numeroComprobante: json['numeroComprobante'],
      fechaEmision: json['fechaEmision'],
      emitidoASunat: json['emitidoASunat'],
      emisor: json['emisor'],
      adquiriente: json['adquiriente'],
      tipoComprobante: json['tipoComprobante'],
      tipoOperacion: json['tipoOperacion'],
      tipoPago: json['tipoPago'],
      resumenDeEmision: json['resumenDeEmision'],
      codigoMoneda: json['codigoMoneda'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serie': serie,
      'numeroComprobante': numeroComprobante,
      'fechaEmision': fechaEmision,
      'emitidoASunat': emitidoASunat,
      'emisor': emisor,
      'adquiriente': adquiriente,
      'tipoComprobante': tipoComprobante,
      'tipoOperacion': tipoOperacion,
      'tipoPago': tipoPago,
      'resumenDeEmision': resumenDeEmision,
      'codigoMoneda': codigoMoneda,
      'estado': estado,
    };
  }
}
