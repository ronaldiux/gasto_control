import 'package:flutter/material.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/pages/cadGasto.dart';
// ignore: unused_import
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool load = true;
  String mes = '';
  int mestela = 0;
  List<Gasto> gastos = [];
  double balanco = 0.0;
  double entrada = 0.0;
  double saida = 0.0;

  @override
  void initState() {
    super.initState();

    initdb();
    setmes(DateTime.now().month);
    mestela = DateTime.now().month;
  }

  initdb() async {
    await SqliteFunc().initCategorias();
  }

  Future<Null> setmes(int mesparam) async {
    switch (mesparam) {
      case 1:
        setState(() {
          mes = 'Janeiro';
        });
        break;
      case 2:
        setState(() {
          mes = 'Fevereiro';
        });
        break;
      case 3:
        setState(() {
          mes = 'Março';
        });
        break;
      case 4:
        setState(() {
          mes = 'Abril';
        });
        break;
      case 5:
        setState(() {
          mes = 'Maio';
        });
        break;
      case 6:
        setState(() {
          mes = 'Junho';
        });
        break;
      case 7:
        setState(() {
          mes = 'Julho';
        });
        break;
      case 8:
        setState(() {
          mes = 'Agosto';
        });
        break;
      case 9:
        setState(() {
          mes = 'Setembro';
        });
        break;
      case 10:
        setState(() {
          mes = 'Outubro';
        });
        break;
      case 11:
        setState(() {
          mes = 'Novembro';
        });
        break;
      case 12:
        setState(() {
          mes = 'Dezembro';
        });
        break;
    }

    init(mesfinal: mesparam, mesinicio: mesparam);
  }

  void init({int mesinicio = 0, int mesfinal = 0}) async {
    setState(() {
      gastos = [];
      load = true;
    });

    await Future.delayed(Duration(milliseconds: 500));
    try {
      if (mesinicio == 0) {
        gastos = await SqliteFunc().getGastos();
      } else {
        gastos = await SqliteFunc()
            .getGastos(ano: 2021, mesfim: mesfinal, mesinicio: mesinicio);
      }

      print('GASTOS=${gastos.length}');
    } catch (e) {
      print(e);
    }
    entrada = 0.0;
    saida = 0.0;
    balanco = 0.0;

    gastos.forEach((element) {
      if (element.tipo == 0) {
        entrada = entrada + element.valor;
      } else {
        saida = saida + element.valor;
      }
    });

    balanco = entrada - saida;

    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Gastos'),
      ),
      drawer: Container(
        width: 200,
        child: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Home Page'),
                ),
                TextButton(
                  onPressed: () {
                    SqliteFunc().limpagasto();
                  },
                  child: Text('Limpar Gastos'),
                ),
                TextButton(
                  onPressed: () async {
                    var res = await Navigator.push(
                        context,
                        new PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CadGasto(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(-2.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));

                    if ('$res' == 'ok') {
                      await setmes(mestela);
                    }

                    //SqliteFunc().insRdmGasto();
                  },
                  child: Text('Inserir Gastos'),
                ),
                TextButton(
                  onPressed: () {
                    SqliteFunc().insRdmGasto();
                  },
                  child: Text('Inserir Gastos - Aleatorio'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await Navigator.push(
              context,
              new PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CadGasto(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(-2.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));

          if ('$res' == 'ok') {
            await setmes(mestela);
          }
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: load
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
                      'Iniciando',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await setmes(mestela);
                },
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: Colors.blue,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (mestela != 1) {
                                mestela = mestela - 1;

                                setmes(mestela);
                              }
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            child: Text(
                              '$mes/2021',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (mestela != 12) {
                                mestela = mestela + 1;

                                setmes(mestela);
                              }
                            },
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListView.builder(
                            //scrollDirection: Axis.horizontal,
                            itemCount: gastos.length,
                            itemBuilder: (context, index) {
                              int a = index % 2;
                              return Card(
                                color: (a == 0)
                                    ? Color.fromRGBO(93, 92, 93, 1)
                                    : Color.fromRGBO(103, 102, 103, 1),
                                child: InkWell(
                                  onTap: () async {
                                    print('gasto id = ${gastos[index].id}');
                                    var res = await Navigator.push(
                                        context,
                                        new PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              CadGasto(
                                            idGasto: gastos[index].id,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            var begin = Offset(-2.0, 0.0);
                                            var end = Offset.zero;
                                            var curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                        ));
                                    if ('$res' == 'ok') {
                                      await setmes(mestela);
                                    }
                                  },
                                  splashColor: Color.fromRGBO(63, 62, 63, 1),
                                  highlightColor: Color.fromRGBO(63, 62, 63, 1),
                                  child: Container(
                                    height: 90,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(gastos[index].descricao),
                                        Text(
                                            '${DateFormat('dd/MM/yyyy').format(gastos[index].data)}'),
                                        Text(gastos[index].formapagamento),
                                        Text((gastos[index].tipo == 0)
                                            ? 'Entrada'
                                            : 'Saida'),
                                        Text(
                                            'R\$ ${gastos[index].valor.toString().replaceAll('.', ',')}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Entradas : R\$ ${entrada.toString().replaceAll('.', ',')}'),
                            Text(
                                'Saidas     : R\$ ${saida.toString().replaceAll('.', ',')}'),
                            Text(
                                'Balanço   : R\$ ${balanco.toString().replaceAll('.', ',')}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
