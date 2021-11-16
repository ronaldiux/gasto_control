class Parcelamento {
  int id;
  String descricao;
  int qntparcelas;
  double valortotal;
  DateTime data;
  bool pago;

  Parcelamento({
    required this.id,
    required this.descricao,
    required this.qntparcelas,
    required this.valortotal,
    required this.data,
    required this.pago,
  });
}
