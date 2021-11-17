import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gasto_control/model/Colors.dart';
import 'package:gasto_control/model/DefaultWidgets.dart';
import 'package:gasto_control/model/Parcelamento.dart';
import 'package:gasto_control/pages/Cadastros/cadParcelamentos.dart';
import 'package:gasto_control/utils/sqliteFunction.dart';
import 'package:intl/intl.dart';

class ParcelamentosLista extends StatefulWidget {
  const ParcelamentosLista({Key? key}) : super(key: key);

  @override
  _ParcelamentosListaState createState() => _ParcelamentosListaState();
}

class _ParcelamentosListaState extends State<ParcelamentosLista> {
  bool isLoading = true;
  List<Parcelamento> parcelamentos = [];

  @override
  void initState() {
    init();

    super.initState();
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    parcelamentos = [];
    parcelamentos = await SqliteFunc().getParcelamentos();

    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Defaultwidgets.dfText(
          'Parcelamentos',
          defaultcolor: Colors.white,
          tamanhofonte: 20,
          fontweight: FontWeight.w500,
        ),
      ),
      body: isLoading
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
          : (parcelamentos.isEmpty)
              ? RefreshIndicator(
                  onRefresh: () async {
                    await init();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.tema1(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      new PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            CadParcelamento(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = Offset(-2.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ));

                                  init();
                                },
                                child: Defaultwidgets.dfText(
                                  'Clique aqui para cadastrar',
                                  defaultcolor: Colors.white,
                                  tamanhofonte: 16,
                                  fontweight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await init();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ListView.builder(
                        itemCount: parcelamentos.length,
                        itemBuilder: (context, index) {
                          //int a = index % 2;
                          return Card(
                            elevation: 3,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () async {},
                              highlightColor: Color.fromRGBO(223, 223, 223, 1),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Defaultwidgets.dfText(
                                              parcelamentos[index].descricao,
                                              defaultcolor: Colors.black,
                                            ),
                                            Defaultwidgets.dfText(
                                              parcelamentos[index]
                                                  .valortotal
                                                  .toStringAsFixed(2),
                                              defaultcolor: Colors.grey,
                                              tamanhofonte: 12,
                                            ),
                                            Defaultwidgets.dfText(
                                              '${DateFormat('dd/MM/yyyy').format(parcelamentos[index].data)}',
                                              defaultcolor: Colors.grey,
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
                                              '${parcelamentos[index].valortotal.toString().replaceAll('.', ',')}',
                                              defaultcolor:
                                                  Colors.green.shade700,
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
    );
  }
}
