class Gasto {
  int id;
  String descricao;
  DateTime data;
  int tipo;
  String categoria;
  double valor;
  String formapagamento;
  bool pago;

  Gasto({
    required this.id,
    required this.descricao,
    required this.data,
    required this.tipo,
    required this.valor,
    required this.categoria,
    required this.formapagamento,
    required this.pago,
  });
}
