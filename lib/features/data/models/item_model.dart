class ItemModel {
  final int id;
  final String nombre;
  final String descripcion;
  final double valorUnitario;
  final int stock;
  final double peso;
  final double volumen;
  final String? codigoBarras;
  final String unidadMedida;
  final String tipoPrecio;
  final String codigoProducto;
  final int categoria;

  ItemModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.valorUnitario,
    required this.stock,
    required this.peso,
    required this.volumen,
    this.codigoBarras,
    required this.unidadMedida,
    required this.tipoPrecio,
    required this.codigoProducto,
    required this.categoria,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      valorUnitario: json['valorUnitario'],
      stock: json['stock'],
      peso: json['peso'],
      volumen: json['volumen'],
      codigoBarras: json['codigoBarras'],
      unidadMedida: json['unidadMedida'],
      tipoPrecio: json['tipoPrecio'],
      codigoProducto: json['codigoProducto'],
      categoria: json['categoria'],
    );
  }
}
