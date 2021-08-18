class Gasto {
  int id;
  String descricao;
  DateTime data;
  int tipo;
  double valor;
  String formapagamento;
  String categoria;
  bool pago;

  Gasto(
      {required this.id,
      required this.descricao,
      required this.data,
      required this.tipo,
      required this.valor,
      required this.formapagamento,
      required this.categoria,
      required this.pago});
}
