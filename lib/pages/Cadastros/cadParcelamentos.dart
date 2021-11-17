// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gasto_control/model/Colors.dart';
import 'package:gasto_control/model/DefaultWidgets.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/model/Parcelamento.dart';
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:gasto_control/widgets/textInput.dart';
import 'package:intl/intl.dart';

class CadParcelamento extends StatefulWidget {
  const CadParcelamento({Key? key}) : super(key: key);

  @override
  _CadParcelamentoState createState() => _CadParcelamentoState();
}

class _CadParcelamentoState extends State<CadParcelamento> {
  static final TextEditingController _descricao = new TextEditingController();
  static final TextEditingController _valor = new TextEditingController();
  static final TextEditingController _parcelas = new TextEditingController();
  static final TextEditingController _nDias = new TextEditingController();

  final FocusNode _descNode = FocusNode();
  final FocusNode _vlrNode = FocusNode();
  final FocusNode _nDiasNode = FocusNode();
  final FocusNode _parcelasNode = FocusNode();
  final FocusNode _formaPagamento = FocusNode();

  bool isLoading = true;

  bool validaValor = false;
  bool validaParcela = false;
  bool validaNdias = false;

  bool hasHint_valor = false;
  String hintText_valor = 'R\$';

  bool hasHint_parcelas = false;
  String hintText_parcelas = 'Parcelas';

  bool hasHint_nDias = false;
  String hintText_nDias = 'Nº Dias';

  String formapagamento = 'Dinheiro';

  DateTime datagasto = DateTime.now();

  List<Gasto> gastoParcelas = [];

  @override
  void initState() {
    init();

    super.initState();

    _vlrNode.addListener(() {
      if (_vlrNode.hasFocus) {
        setState(() {
          hintText_valor = '';
          hasHint_valor = false;
        });
      } else {
        setState(() {
          hintText_valor = 'R\$';
          hasHint_valor = true;
        });
      }

      if (_valor.text == '') {
        setState(() {
          _valor.text = '0,00';
        });
      }
    });

    _parcelasNode.addListener(() {
      if (_parcelas.text == '') {
        setState(() {
          _parcelas.text = '1';
        });
      }

      if (_parcelasNode.hasFocus) {
        setState(() {
          hintText_valor = '';
          hasHint_parcelas = false;
        });
      } else {
        setState(() {
          hintText_valor = 'Parcelas';
          hasHint_parcelas = true;
        });
      }
    });

    _nDiasNode.addListener(() {
      if (_nDiasNode.hasFocus) {
        setState(() {
          hintText_nDias = '';
          hasHint_nDias = false;
        });
      } else {
        setState(() {
          hintText_nDias = 'Nº Dias';
          hasHint_nDias = true;
        });
      }

      if (_nDias.text == '') {
        setState(() {
          _nDias.text = '30';
        });
      }
    });
  }

  @override
  void dispose() {
    _vlrNode.dispose();

    _nDias.text = '30';
    _descricao.text = '';
    _parcelas.text = '1';
    _valor.text = '0,0';
    gastoParcelas = [];
    datagasto = DateTime.now();

    super.dispose();
  }

  init() async {
    _nDias.text = '30';
    _descricao.text = '';
    _parcelas.text = '1';
    _valor.text = '0,0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.tema1(),
        title: Defaultwidgets.dfText(
          'Cadastrar',
          defaultcolor: Colors.white,
          tamanhofonte: 20,
          fontweight: FontWeight.w500,
        ),
      ),
      body: !isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.tema1(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Carregando ...',
                      style:
                          TextStyle(fontSize: 18, color: CustomColors.tema1()),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
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
                        fieldSubmitted: (_) {},
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
                        hinttxt: 'Valor Total',
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
                      padding: EdgeInsets.all(5),
                      child: CustomFormField(
                        ctrl: _parcelas,
                        prefixtext: 'Parcelas ',
                        hinttxt: '',
                        lblcolor: CustomColors.tema1(),
                        enabled: true,
                        fcs: _parcelasNode,
                        fontColor: CustomColors.tema1(),
                        keyboardType: TextInputType.number,
                        decorationColor: Colors.white,
                        txtInputAction: TextInputAction.next,
                        radius: 3,
                        fieldSubmitted: (_) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: CustomFormField(
                        ctrl: _nDias,
                        prefixtext: 'Nº Dias ',
                        hinttxt: '',
                        lblcolor: CustomColors.tema1(),
                        enabled: true,
                        fcs: _nDiasNode,
                        fontColor: CustomColors.tema1(),
                        keyboardType: TextInputType.number,
                        decorationColor: Colors.white,
                        txtInputAction: TextInputAction.next,
                        radius: 3,
                        fieldSubmitted: (_) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
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
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: DateTimeFormField(
                            initialValue: datagasto,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'Data Inicial',
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
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: double.maxFinite,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.tema2(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            print('== GERANDO PARCELAS ==');

                            double valorT = 0;
                            int parcelas = 0;
                            int nDias = 30;

                            if (_valor.text.isNotEmpty) {
                              try {
                                valorT = double.parse(_valor.text
                                    .replaceAll('.', '')
                                    .replaceAll(',', '.'));
                                validaValor = true;

                                if (valorT == 0.0) {
                                  validaValor = false;
                                }

                                print('valor = $validaValor');
                              } catch (e) {
                                validaValor = false;
                                print('Erro valor total=$e');
                              }
                            }

                            if (_nDias.text.isNotEmpty) {
                              try {
                                nDias = int.parse(_nDias.text);
                                validaNdias = true;

                                if (nDias == 0) {
                                  validaNdias = false;
                                }

                                print('nDias = $validaNdias');
                              } catch (e) {
                                validaNdias = false;
                                print('Erro nDias=$e');
                              }
                            }

                            if (_parcelas.text.isNotEmpty) {
                              try {
                                parcelas = int.parse(_parcelas.text);
                                validaParcela = true;
                                if (parcelas == 0) {
                                  validaParcela = false;
                                }

                                print('Parcelas = $validaParcela($parcelas)');
                              } catch (e) {
                                validaParcela = false;
                                print('Erro parcelas=$e');
                              }
                            }

                            if (validaParcela && validaValor && validaNdias) {
                              gastoParcelas = [];
                              //DateTime dataTemp = datagasto;

                              for (var i = 0; i <= parcelas - 1; i++) {
                                DateTime ndataTemp =
                                    datagasto.add(Duration(days: nDias * i));

                                print(
                                    'add-gasto data(${DateFormat('dd/MM/yyyy').format(datagasto)})');

                                var tempGasto = Gasto(
                                  categoria: 'Parcela',
                                  data: ndataTemp,
                                  descricao: 'Parcela $i/$parcelas',
                                  formapagamento: formapagamento,
                                  id: 0,
                                  pago: false,
                                  tipo: 1,
                                  valor: valorT / parcelas,
                                );

                                setState(() {
                                  gastoParcelas.add(tempGasto);
                                });

                                print(
                                    'add-gasto count=(${gastoParcelas.length})');
                              }

                              gastoParcelas.forEach((element) {
                                print(
                                    'GASTO(${element.descricao}||${element.data}||${element.valor})');
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  behavior: SnackBarBehavior.floating,
                                  padding: EdgeInsets.all(10),
                                  //width: 150,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  content: Container(
                                    child: Defaultwidgets.dfText(
                                      "Parcelas Geradas",
                                      tamanhofonte: 18,
                                      defaultcolor: CustomColors.tema1(),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              List<String> campos = [];

                              if (!validaValor) {
                                campos.add('Valor');
                              }
                              if (!validaParcela) {
                                campos.add('Parcela');
                              }
                              if (!validaNdias) {
                                campos.add('Nº Dias');
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  padding: EdgeInsets.all(10),
                                  //width: 150,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  content: Container(
                                    child: Defaultwidgets.dfText(
                                      "Verifique o(s) campo(s) $campos",
                                      tamanhofonte: 18,
                                      defaultcolor: Colors.white,
                                    ),
                                  ),
                                ),
                              );

                              print('not-valid');
                            }
                          },
                          child: Text(
                            'Gerar Parcelas',
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
                    (gastoParcelas.isEmpty)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: ListView.builder(
                                  itemCount: gastoParcelas.length,
                                  itemBuilder: (context, index) {
                                    //int a = index % 2;
                                    return Card(
                                      elevation: 3,
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () async {},
                                        highlightColor:
                                            Color.fromRGBO(223, 223, 223, 1),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .moneyBillAlt,
                                                      color:
                                                          (gastoParcelas[index]
                                                                      .tipo ==
                                                                  0)
                                                              ? Colors.green
                                                                  .shade700
                                                              : Colors
                                                                  .red.shade400,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 200,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Defaultwidgets.dfText(
                                                        gastoParcelas[index]
                                                            .descricao,
                                                        defaultcolor:
                                                            Colors.black,
                                                      ),
                                                      Defaultwidgets.dfText(
                                                        gastoParcelas[index]
                                                            .categoria,
                                                        defaultcolor:
                                                            Colors.grey,
                                                        tamanhofonte: 12,
                                                      ),
                                                      Defaultwidgets.dfText(
                                                        '${DateFormat('dd/MM/yyyy').format(gastoParcelas[index].data)}',
                                                        defaultcolor:
                                                            Colors.black,
                                                        tamanhofonte: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Defaultwidgets.dfText(
                                                        '${gastoParcelas[index].valor.toString().replaceAll('.', ',')}',
                                                        defaultcolor:
                                                            (gastoParcelas[index]
                                                                        .tipo ==
                                                                    0)
                                                                ? Colors.green
                                                                    .shade700
                                                                : Colors.red
                                                                    .shade400,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                    (gastoParcelas.isEmpty)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: double.maxFinite,
                              height: 45,
                              decoration: BoxDecoration(
                                color: CustomColors.tema2(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  int idlastParc =
                                      await SqliteFunc().getLastParcelamento();

                                  var parcela = Parcelamento(
                                    id: 0,
                                    descricao: (_descricao.text.isEmpty)
                                        ? 'Parcelamento $idlastParc'
                                        : _descricao.text,
                                    qntparcelas: int.parse(_parcelas.text),
                                    valortotal: double.parse(_valor.text
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.')),
                                    data: datagasto,
                                    pago: false,
                                    pulaDias: int.parse(_nDias.text),
                                    formapagamento: formapagamento,
                                  );

                                  var a = await SqliteFunc()
                                      .insParcelamento(parcela);

                                  if (a == 'ok') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(10),
                                        //width: 150,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        content: Container(
                                          child: Defaultwidgets.dfText(
                                            "Salvo Com Sucesso, Gerando Parcelas",
                                            tamanhofonte: 18,
                                            defaultcolor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                    await Future.delayed(
                                        Duration(milliseconds: 200));

                                    int idParcelamento = await SqliteFunc()
                                        .getLastParcelamento();

                                    try {
                                      for (var gastos in gastoParcelas) {
                                        await SqliteFunc().insGasto(gastos,
                                            idparcelamento: idParcelamento);
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(10),
                                          //width: 150,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          content: Container(
                                            child: Defaultwidgets.dfText(
                                              "Parcelas Geradas!!",
                                              tamanhofonte: 18,
                                              defaultcolor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });

                                      await Future.delayed(
                                          Duration(milliseconds: 100));
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(10),
                                          //width: 150,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          content: Container(
                                            child: Defaultwidgets.dfText(
                                              "Erro ao gerar Parcelas\r\n$e",
                                              tamanhofonte: 18,
                                              defaultcolor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(10),
                                        //width: 150,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        content: Container(
                                          child: Defaultwidgets.dfText(
                                            "Erro: $a",
                                            tamanhofonte: 18,
                                            defaultcolor: Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Salvar Parcelamento',
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
                  ],
                ),
              ),
            ),
    );
  }
}
