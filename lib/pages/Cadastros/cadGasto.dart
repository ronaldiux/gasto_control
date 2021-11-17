import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/model/categoria_model.dart';
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:gasto_control/widgets/textInput.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:gasto_control/model/Colors.dart';

class CadGasto extends StatefulWidget {
  final int idGasto;
  const CadGasto({Key? key, this.idGasto = 0}) : super(key: key);

  @override
  _CadGastoState createState() => _CadGastoState();
}

class _CadGastoState extends State<CadGasto> {
  static final TextEditingController _descricao = new TextEditingController();
  static final TextEditingController _valor = new TextEditingController();

  final FocusNode _descNode = FocusNode();
  final FocusNode _vlrNode = FocusNode();

  final FocusNode _tipo = FocusNode();
  final FocusNode _formaPagamento = FocusNode();
  final FocusNode _categoria = FocusNode();

  bool isLoading = true;
  String hintText = 'R\$';
  String tipogasto = 'Saida(-)';
  String categoriaName = 'Outras Despesas';
  String formapagamento = 'Dinheiro';
  bool hasHint = false;
  List<Categoria> categorias = [];

  DateTime datagasto = DateTime.now();

  @override
  void initState() {
    _vlrNode.addListener(() {
      if (_vlrNode.hasFocus) {
        setState(() {
          hintText = '';
          hasHint = false;
        });
      } else {
        setState(() {
          hintText = 'R\$';
          hasHint = true;
        });
      }

      if (_valor.text == '') {
        setState(() {
          _valor.text = '0,00';
        });
      }
    });

    init();

    super.initState();
  }

  @override
  void dispose() {
    _vlrNode.dispose();

    super.dispose();
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    categorias = await SqliteFunc().getCategorias();

    if (widget.idGasto != 0) {
      Gasto gst = await SqliteFunc().getgastoid(widget.idGasto);

      if (gst.categoria.trim() == '') {
        categoriaName = categorias[0].descricao;
      } else {
        categoriaName = gst.categoria;
      }

      _descricao.text = gst.descricao;
      _valor.text = gst.valor.toString().replaceAll('.', ',');
      datagasto = gst.data;

      if (gst.tipo == 0) {
        tipogasto = 'Entrada(+)';
      } else {
        tipogasto = 'Saida(-)';
      }
    } else {
      categoriaName = categorias[0].descricao;
      _descricao.text = '';
      _valor.text = '0,00';
    }

    setState(() {
      isLoading = false;
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.tema1(),
        title: Text((widget.idGasto == 0) ? 'Cadastrar' : 'Editar'),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.tema1(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Carregando',
                        style: TextStyle(
                            fontSize: 18, color: CustomColors.tema1()),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: CustomFormField(
                            maxLength: 100,
                            //autoFocus: true,
                            ctrl: _descricao,
                            hinttxt: 'Descrição',
                            lblcolor: CustomColors.tema1(),
                            enabled: true,
                            fcs: _descNode,
                            fontColor: CustomColors.tema1(),
                            keyboardType: TextInputType.text,
                            decorationColor: Colors.white,
                            txtInputAction: TextInputAction.next,
                            radius: 3,
                            fieldSubmitted: (_) {
                              _fieldFocusChange(context, _descNode, _vlrNode);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: CustomFormField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'pt-br',
                                decimalDigits: 2,
                                symbol: '',
                              )
                            ],
                            lblcolor: CustomColors.tema1(),
                            prefixtext: 'R\$ ',
                            ctrl: _valor,
                            hinttxt: 'Valor',
                            enabled: true,
                            fcs: _vlrNode,
                            radius: 3,
                            fontColor: CustomColors.tema1(),
                            keyboardType: TextInputType.number,
                            decorationColor: Colors.white,
                            txtInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DateTimeFormField(
                                initialValue: datagasto,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.event_note),
                                  labelText: 'Data',
                                  labelStyle: TextStyle(
                                    color: CustomColors.tema1(),
                                  ),
                                ),
                                //firstDate: datagasto,
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode: AutovalidateMode.always,
                                dateTextStyle: TextStyle(
                                  color: CustomColors.tema1(),
                                ),
                                validator: (e) {},
                                onDateSelected: (DateTime value) {
                                  datagasto = value;
                                  // print(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton<String>(
                                onTap: () {
                                  _tipo.requestFocus();
                                },
                                isExpanded: true,
                                focusNode: _tipo,
                                style: TextStyle(
                                  color: CustomColors.tema1(),
                                  fontSize: 16,
                                ),
                                dropdownColor: Colors.white,
                                value: tipogasto,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    tipogasto = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Entrada(+)',
                                  'Saida(-)'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton<String>(
                                onTap: () {
                                  _formaPagamento.requestFocus();
                                },
                                isExpanded: true,
                                focusNode: _formaPagamento,
                                style: TextStyle(
                                    color: CustomColors.tema1(), fontSize: 16),
                                dropdownColor: Colors.white,
                                value: formapagamento,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    formapagamento = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Crédito',
                                  'Dinheiro',
                                  'Débito',
                                  'Parcelado'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            width: double.infinity,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: DropdownButton(
                                onTap: () {
                                  _categoria.requestFocus();
                                },
                                focusNode: _categoria,
                                isExpanded: true,
                                value: categoriaName,
                                style: TextStyle(
                                    color: CustomColors.tema1(), fontSize: 16),
                                dropdownColor: Colors.white,
                                onChanged: (newValue) {
                                  setState(() {
                                    categoriaName = newValue.toString();

                                    if (_descricao.text == '') {
                                      _descricao.text = categoriaName;
                                    }
                                  });
                                },
                                items: categorias.map((strCategorias) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      strCategorias.descricao.trim(),
                                      overflow: TextOverflow.visible,
                                    ),
                                    value: strCategorias.descricao.trim(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: double.maxFinite,
                            height: 45,
                            decoration: BoxDecoration(
                                color: CustomColors.tema2(),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              onPressed: () async {
                                String res = '';
                                String strvalor = _valor.text;
                                strvalor = strvalor.replaceAll('.', '');
                                strvalor = strvalor.replaceAll(',', '.');
                                double valor = double.parse(strvalor);

                                print(valor);

                                setState(() {
                                  isLoading = true;
                                });

                                if (widget.idGasto == 0) {
                                  Gasto gst = Gasto(
                                    id: 0,
                                    descricao: _descricao.text,
                                    data: datagasto,
                                    tipo: (tipogasto == 'Entrada(+)') ? 0 : 1,
                                    valor: valor,
                                    formapagamento: formapagamento,
                                    pago: false,
                                    categoria: categoriaName,
                                  );

                                  res = await SqliteFunc().insGasto(gst);
                                } else {
                                  Gasto gst = Gasto(
                                    id: widget.idGasto,
                                    descricao: _descricao.text,
                                    data: datagasto,
                                    tipo: (tipogasto == 'Entrada(+)') ? 0 : 1,
                                    valor: valor,
                                    formapagamento: formapagamento,
                                    pago: false,
                                    categoria: categoriaName,
                                  );

                                  res = await SqliteFunc().updateGasto(gst);
                                }
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                setState(() {
                                  isLoading = false;
                                });

                                if (res == 'ok') {
                                  Navigator.pop(context, 'ok');
                                }
                              },
                              child: Text(
                                'Salvar',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (widget.idGasto == 0)
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: double.maxFinite,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: CustomColors.vermelho(),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      var res = await SqliteFunc()
                                          .delegasto(widget.idGasto);

                                      await Future.delayed(
                                          Duration(milliseconds: 500));
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (res == 'ok') {
                                        Navigator.pop(context, 'ok');
                                      }
                                    },
                                    child: Text(
                                      'Apagar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
