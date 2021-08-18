import 'dart:ffi';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:gasto_control/model/Categoria.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:gasto_control/widgets/textInput.dart';
import 'package:intl/intl.dart';

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

  bool isLoading = true;
  String hintText = 'R\$';
  String tipogasto = 'Entrada';
  String categoriaGasto = '';
  bool hasHint = false;
  DateTime datagasto = DateTime.now();
  List<Categoria> categorias = [];
  List<String> strCategorias = [];

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    _vlrNode.dispose();

    super.dispose();
  }

  init() async {
    categorias = await SqliteFunc().getCategorias();
    categorias.forEach((element) {
      strCategorias.add(element.descricao);
    });
    print(categorias.length);
    print(strCategorias);

    if (widget.idGasto != 0) {
      Gasto gst = await SqliteFunc().getgastoid(widget.idGasto);

      _descricao.text = gst.descricao;
      _valor.text = gst.valor.toString();
      datagasto = gst.data;
      if (gst.tipo == 0) {
        tipogasto = 'Entrada';
      } else {
        tipogasto = 'Saida';
      }
    } else {
      _descricao.text = '';
      _valor.text = '0,00';
    }
    categoriaGasto = strCategorias[0];

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
        title: Text((widget.idGasto == 0) ? 'Cadastro' : 'Edição'),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Carregando',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: CustomFormField(
                      ctrl: _descricao,
                      hinttxt: 'Descrição',
                      lblcolor: Colors.white,
                      enabled: true,
                      fcs: _descNode,
                      keyboardType: TextInputType.text,
                      decorationColor: Colors.grey.shade400,
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
                      lblcolor: Colors.white,
                      prefixtext: 'R\$ ',
                      ctrl: _valor,
                      hinttxt: 'Valor',
                      enabled: true,
                      fcs: _vlrNode,
                      radius: 3,
                      keyboardType: TextInputType.number,
                      decorationColor: Colors.grey.shade400,
                      txtInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: DateTimeFormField(
                          initialValue: datagasto,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Data',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          //firstDate: datagasto,
                          dateFormat: DateFormat('dd/MM/yyyy'),
                          mode: DateTimeFieldPickerMode.date,
                          autovalidateMode: AutovalidateMode.always,
                          dateTextStyle: TextStyle(color: Colors.white),
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
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      width: double.infinity,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton<String>(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          dropdownColor: Colors.white,
                          value: tipogasto,
                          onChanged: (String? newValue) {
                            setState(() {
                              tipogasto = newValue!;
                            });
                          },
                          items: <String>['Entrada', 'Saida']
                              .map<DropdownMenuItem<String>>((String value) {
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
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: DropdownButton(
                          isExpanded: true,
                          value: categoriaGasto,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          dropdownColor: Colors.white,
                          onChanged: (newValue) {
                            setState(() {
                              categoriaGasto = newValue.toString();
                            });
                          },
                          items: strCategorias.map((strCategorias) {
                            return DropdownMenuItem(
                              child: Text(
                                strCategorias.trim(),
                                overflow: TextOverflow.visible,
                              ),
                              value: strCategorias.trim(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
