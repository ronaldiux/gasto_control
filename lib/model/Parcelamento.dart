class Parcelamento {
  int id;
  String descricao;
  String formapagamento;
  int qntparcelas;
  int pulaDias;
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
    required this.pulaDias,
    required this.formapagamento,
  });
}
