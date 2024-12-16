import 'package:qikcart/features/domain/entities/comprobante.dart';

class ComprobanteModel extends Comprobante {
  const ComprobanteModel({
    super.id,
    required super.serie,
    required super.numeroComprobante,
    super.fechaEmision,
    required super.emitidoASunat,
    required super.emisor,
    required super.adquiriente,
    required super.tipoComprobante,
    required super.tipoOperacion,
    required super.tipoPago,
    super.resumenDeEmision,
    required super.codigoMoneda,
    super.estado,
  });

  factory ComprobanteModel.fromJson(Map<String, dynamic> json) {
    return ComprobanteModel(
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

  factory ComprobanteModel.fromEntity(Comprobante comprobante) {
    return ComprobanteModel(
      id: comprobante.id,
      serie: comprobante.serie,
      numeroComprobante: comprobante.numeroComprobante,
      fechaEmision: comprobante.fechaEmision,
      emitidoASunat: comprobante.emitidoASunat,
      emisor: comprobante.emisor,
      adquiriente: comprobante.adquiriente,
      tipoComprobante: comprobante.tipoComprobante,
      tipoOperacion: comprobante.tipoOperacion,
      tipoPago: comprobante.tipoPago,
      resumenDeEmision: comprobante.resumenDeEmision,
      codigoMoneda: comprobante.codigoMoneda,
      estado: comprobante.estado,
    );
  }
}
