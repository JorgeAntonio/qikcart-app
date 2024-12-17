class ItemCreate {
  final String nombre;
  final String descripcion;
  final double valorUnitario;
  final int stock;
  final int peso;
  final int volumen;
  final String codigoBarras;
  final String unidadMedida;
  final String tipoPrecio;
  final String codigoProducto;
  final String categoria;

  ItemCreate({
    required this.nombre,
    required this.descripcion,
    required this.valorUnitario,
    required this.stock,
    required this.peso,
    required this.volumen,
    required this.codigoBarras,
    required this.unidadMedida,
    required this.tipoPrecio,
    required this.codigoProducto,
    required this.categoria,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'valorUnitario': valorUnitario,
      'stock': stock,
      'peso': peso,
      'volumen': volumen,
      'codigoBarras': codigoBarras,
      'unidadMedida': unidadMedida,
      'tipoPrecio': tipoPrecio,
      'codigoProducto': codigoProducto,
      'categoria': categoria,
    };
  }
}
