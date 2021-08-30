import 'package:flutter/material.dart';
import 'package:gasto_control/model/Colors.dart';
import 'package:gasto_control/model/DefaultWidgets.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/pages/cadGasto.dart';
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey columMenukey = GlobalKey();
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
        title: Defaultwidgets.dfText('Controle de Gastos',
            defaultcolor: Colors.white,
            tamanhofonte: 18,
            align: TextAlign.center),
        backgroundColor: CustomColors.tema1(),
      ),
      drawer: Container(
        width: 200,
        child: SafeArea(
          child: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              key: columMenukey,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Defaultwidgets.dfText(
                        'Home Page',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          new PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CadGasto(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Defaultwidgets.dfText(
                        'Parcelamentos',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          new PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CadGasto(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Defaultwidgets.dfText(
                        'Inserir Gastos',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ExpansionTile(
                  title: Defaultwidgets.dfText('Administrativo'),
                  collapsedIconColor: CustomColors.tema1(),
                  collapsedTextColor: CustomColors.tema1(),
                  textColor: CustomColors.tema1(),
                  iconColor: CustomColors.tema1(),
                  childrenPadding: EdgeInsets.all(5),
                  backgroundColor: Colors.grey[200],
                  children: [
                    TextButton(
                      onPressed: () {
                        SqliteFunc().insRdmGasto();
                      },
                      child: Container(
                        width: double.infinity,
                        child:
                            Defaultwidgets.dfText('Inserir Gastos Aleatorio'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        SqliteFunc().limpagasto();
                      },
                      child: Container(
                          width: double.infinity,
                          child: Defaultwidgets.dfText('Limpar Gastos')),
                    ),
                    TextButton(
                      onPressed: () async {
                        await SqliteFunc().clearcategorias();
                        await SqliteFunc().initCategorias();
                      },
                      child: Container(
                          width: double.infinity,
                          child: Defaultwidgets.dfText('Resetar Categorias')),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
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
        backgroundColor: CustomColors.tema2(),
        child: Icon(Icons.add),
      ),
      body: Container(
        child: load
            ? Center(
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
                    Defaultwidgets.dfText(
                      'Carregando',
                      tamanhofonte: 18,
                    )
                  ],
                ),
              )
            : RefreshIndicator(
                color: CustomColors.tema2(),
                onRefresh: () async {
                  await setmes(mestela);
                },
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: CustomColors.tema2(),
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
                            child: Defaultwidgets.dfText('$mes/2021',
                                tamanhofonte: 18, defaultcolor: Colors.white),
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
                                    ? Color.fromRGBO(213, 212, 213, 1)
                                    : Color.fromRGBO(183, 182, 183, 1),
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
                                  //splashColor: Color.fromRGBO(63, 62, 63, 1),
                                  highlightColor:
                                      Color.fromRGBO(223, 223, 223, 1),
                                  child: Container(
                                    height: 100,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Defaultwidgets.dfText(
                                                  gastos[index].descricao,
                                                  defaultcolor: Colors.black),
                                              Defaultwidgets.dfText(
                                                  '${DateFormat('dd/MM/yyyy').format(gastos[index].data)}',
                                                  defaultcolor: Colors.black),
                                              //Defaultwidgets.dfText(
                                              //     gastos[index].formapagamento,
                                              //    defaultcolor: Colors.black),
                                              Defaultwidgets.dfText(
                                                  (gastos[index].tipo == 0)
                                                      ? 'Entrada'
                                                      : 'Saida',
                                                  defaultcolor: Colors.black),
                                              Defaultwidgets.dfText(
                                                  'R\$ ${gastos[index].valor.toString().replaceAll('.', ',')}',
                                                  defaultcolor: Colors.black),
                                            ],
                                          ),
                                        ),
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
                            Defaultwidgets.dfText(
                              'Entradas : R\$ ${entrada.toString().replaceAll('.', ',')}',
                              defaultcolor: CustomColors.tema2(),
                            ),
                            Defaultwidgets.dfText(
                              'Saidas    : R\$ ${saida.toString().replaceAll('.', ',')}',
                              defaultcolor: CustomColors.vermelho(),
                            ),
                            Defaultwidgets.dfText(
                              'Balanço  : R\$ ${balanco.toString().replaceAll('.', ',')}',
                              defaultcolor: (balanco > 0)
                                  ? CustomColors.tema1()
                                  : (balanco == 0)
                                      ? Colors.black
                                      : CustomColors.vermelho(),
                            ),
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
