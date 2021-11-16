import 'dart:math';
import 'package:gasto_control/model/Gasto.dart';
import 'package:gasto_control/model/Parcelamento.dart';
import 'package:gasto_control/model/categoria_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SqliteFunc {
  Future<String> limpagasto() async {
    final Database db = await getDatabase();
    db.delete('gasto');

    return '';
  }

  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  Future<String> insGasto(Gasto gst, {int idparcelamento = 0}) async {
    final Database db = await getDatabase();

    print('data=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

    try {
      db.insert('gasto', {
        'descricao': gst.descricao,
        'data': DateFormat('yyyy-MM-dd').format(gst.data),
        'tipo': gst.tipo,
        'valor': gst.valor,
        'formapagamento': gst.formapagamento,
        'pago': (gst.pago) ? 1 : 0,
        'id_parcelamento': idparcelamento,
        'categoria': gst.categoria,
      });
      print('ok');
      return 'ok';
    } catch (e) {
      print('ERRO AO INSERIR=$e');
      return '$e';
    }
  }

  Future<String> updateGasto(Gasto gst, {int idparcelamento = 0}) async {
    final Database db = await getDatabase();

    print('data=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

    try {
      db.update(
          'gasto',
          {
            'descricao': gst.descricao,
            'data': DateFormat('yyyy-MM-dd').format(gst.data),
            'tipo': gst.tipo,
            'valor': gst.valor,
            'formapagamento': gst.formapagamento,
            'pago': gst.pago,
            'id_parcelamento': idparcelamento,
            'categoria': gst.categoria,
          },
          where: 'id = ?',
          whereArgs: [gst.id]);
      print('ok');
      return 'ok';
    } catch (e) {
      print(e);
      return '$e';
    }
  }

  Future<String> insRdmGasto() async {
    final Database db = await getDatabase();
    String ms = '${random(100, 999)}';
    int tipo = random(0, 2);

    print(tipo);
    print('data=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');
    try {
      db.insert('gasto', {
        'descricao': 'teste $ms',
        'data': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'tipo': (tipo == 0) ? 0 : 1,
        'valor': random(1, 100),
        'formapagamento': 'A Vista',
        'pago': 0,
        'id_parcelamento': 0,
        'categoria': 'Entertenimento',
      });
      print('ok');
      return 'ok';
    } catch (e) {
      print(e);
      return '$e';
    }
  }

  Future<Gasto> getgastoid(int id) async {
    final Database db = await getDatabase();

    late Gasto gst;

    List<Map<String, dynamic>> maps = [];
    maps = await db.query('gasto', where: 'id = ?', whereArgs: [id]);

    maps.forEach((element) {
      bool pago = false;
      if (element['pago'] == '0') {
        pago = false;
      } else {
        pago = true;
      }

      DateTime data = DateTime.now();
      double valor = 0.0;
      int tipo = 1;

      try {
        data = DateTime.parse(element['data']);
      } catch (e) {
        print('Erro na data $e');
      }

      try {
        valor = element['valor'];
      } catch (e) {
        print('Erro no valor $e');
      }

      try {
        tipo = element['tipo'];
      } catch (e) {
        print('Erro no tipo $e');
      }

      gst = new Gasto(
        id: element['id'],
        data: data,
        descricao: '${element['descricao']}',
        formapagamento: '${element['formapagamento']}',
        pago: pago,
        tipo: tipo,
        valor: valor,
        categoria: '${element['categoria']}',
      );

      print(gst.descricao);
    });
    return gst;
  }

  Future<List<Gasto>> getGastos(
      {int mesinicio = 0, int mesfim = 0, int ano = 0}) async {
    final Database db = await getDatabase();
    List<Gasto> gastos = [];
    List<Map<String, dynamic>> maps = [];

    var now = new DateTime.now();

// Find the last day of the month.
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    var lastDay = beginningNextMonth.subtract(new Duration(days: 1)).day;

    if (mesinicio == 0) {
      maps = await db.query('gasto');
    } else {
      var dateinit = new DateTime(ano, mesinicio, 1);
      var datefim = new DateTime(ano, mesfim, lastDay);

      print('where = $dateinit||$datefim');

      maps = await db.query('gasto',
          where: 'data BETWEEN ? AND ?',
          whereArgs: [
            DateFormat('yyyy-MM-dd').format(dateinit),
            DateFormat('yyyy-MM-dd').format(datefim)
          ],
          orderBy: 'data,valor');
    }

    print('FOREACH-ADDLISTA');
    maps.forEach((element) {
      bool pago = false;
      if (element['pago'] == '0') {
        pago = false;
      } else {
        pago = true;
      }

      var dr = new Gasto(
        data: DateTime.parse(element['data']),
        descricao: element['descricao'],
        formapagamento: element['formapagamento'],
        id: element['id'],
        pago: pago,
        tipo: element['tipo'],
        valor: element['valor'],
        categoria: element['categoria'],
      );

      gastos.add(dr);
    });
    return gastos;
  }

  Future<List<Parcelamento>> getParcelamentos() async {
    final Database db = await getDatabase();

    List<Parcelamento> parcelamentos = [];
    List<Map<String, dynamic>> maps = [];

    maps = await db.query('parcelamentos');

    maps.forEach((element) {
      bool pago = false;
      if (element['pago'] == 'false') {
        pago = false;
      } else {
        pago = true;
      }

      var dr = new Parcelamento(
        id: element['id'],
        pago: pago,
        data: DateTime.parse(element['data']),
        descricao: element['descricao'],
        qntparcelas: element['qntparcelas'],
        valortotal: element['valortotal'],
      );

      parcelamentos.add(dr);
    });

    return parcelamentos;
  }

  Future<int> getLastParcelamento() async {
    int lastParce = 0;

    final Database db = await getDatabase();

    List<Map> list =
        await db.rawQuery('SELECT max(id) as lastInsert FROM parcelamentos');

    if (list.length == 1) {
      String lasInsertid = list[0]['lastInsert'].toString();
      lastParce = int.parse(lasInsertid);
    }

    return lastParce;
  }

  Future<List<Categoria>> getCategorias(
      {String filtro = '', String campo = ''}) async {
    final Database db = await getDatabase();
    List<Categoria> categorias = [];

    List<Map<String, dynamic>> maps = [];

    if (filtro.isEmpty && campo.isEmpty) {
      maps = await db.query('categorias', orderBy: 'descricao');
    } else {
      // filtro = columnId = ?
      maps = await db.query(
        'categorias',
        orderBy: 'descricao',
        where: filtro,
        whereArgs: [campo],
      );
    }

    print('CATEGORIAS=${maps.length}');
    maps.forEach((element) {
      var def = new Categoria(
          id: element['id'],
          descricao: element['descricao'],
          tipo: element['tipo']);

      categorias.add(def);
    });

    return categorias;
  }

  Future<String> insParcelamento(Parcelamento parcelamento) async {
    final Database db = await getDatabase();

    print('data=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

    try {
      db.insert('parcelamentos', {
        'descricao': parcelamento.descricao,
        'qntparcelas': parcelamento.qntparcelas,
        'valortotal': parcelamento.valortotal,
        'data': DateFormat('yyyy-MM-dd').format(parcelamento.data),
        'pago': parcelamento.pago,
      });
      print('ok');
      return 'ok';
    } catch (e) {
      print(e);
      return '$e';
    }
  }

  Future initCategorias() async {
    final Database db = await getDatabase();

    List<Map> list = await db.query('categorias');

    if (list.length < 8) {
      await db.insert(
        'categorias',
        {'descricao': 'Entertenimento', 'tipo': '-'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.insert('categorias', {
        'descricao': 'Saúde',
        'tipo': '-',
      });

      await db.insert('categorias', {
        'descricao': 'Transporte/Veiculo',
        'tipo': '-',
      });

      await db.insert('categorias', {
        'descricao': 'Bares/Restaurantes',
        'tipo': '-',
      });

      await db.insert('categorias', {
        'descricao': 'Moradia',
        'tipo': '-',
      });

      await db.insert('categorias', {
        'descricao': 'Remuneração',
        'tipo': '+',
      });

      await db.insert('categorias', {
        'descricao': 'Outras Despesas',
        'tipo': '-',
      });

      await db.insert('categorias', {
        'descricao': 'Outras Receitas',
        'tipo': '+',
      });
    }
  }

  Future<Database> getDatabase() async {
    List<String> sqlrun = [];

    sqlrun.add("CREATE TABLE IF NOT EXISTS gasto (" +
        "  id INTEGER PRIMARY KEY ASC AUTOINCREMENT," +
        "  descricao STRING (500)," +
        "  data DATE NOT NULL," +
        "  tipo            INTEGER NOT NULL," +
        "  valor           DOUBLE NOT NULL," +
        "  categoria       INTEGER NOT NULL," +
        "  formapagamento  STRING (200)," +
        "  pago            INTEGER NOT NULL," +
        "  id_parcelamento INTEGER );");

    sqlrun.add("CREATE TABLE IF NOT EXISTS parcelamentos (" +
        " id          INTEGER PRIMARY KEY AUTOINCREMENT," +
        " descricao   STRING," +
        " qntparcelas INTEGER NOT NULL," +
        " valortotal  DOUBLE  NOT NULL," +
        " data        DATE    NOT NULL," +
        " pago        BOOLEAN NOT NULL );");

    sqlrun.add("CREATE TABLE IF NOT EXISTS formaspagamento (" +
        " id        INTEGER  PRIMARY KEY AUTOINCREMENT," +
        " descricao STRING (200) NOT NULL);");

    sqlrun.add("CREATE TABLE IF NOT EXISTS categorias (" +
        "id        INTEGER      PRIMARY KEY AUTOINCREMENT," +
        "descricao STRING (500)," +
        "tipo STRING (1) );");

    String createtableappuser = '';

    sqlrun.forEach((sqlr) {
      createtableappuser = '$createtableappuser$sqlr';
    });

    return openDatabase(
      // join faz aa/ + /a = aa/a
      p.join(await getDatabasesPath(), 'control_gastosV1.db'),
      version: 1,
      onOpen: (db) {
        print('OPEN DATABASE');
        try {
          sqlrun.forEach((element) {
            db.execute(element);
            print('exec=$element');
          });
        } catch (e) {
          print(e);
        }
      },
      onCreate: (db, version) {
        print('CREATE DATABASE');

        try {
          sqlrun.forEach((element) {
            db.execute(element);
            print('exec=$element');
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }

  Future<String> delegasto(int id) async {
    try {
      final Database db = await getDatabase();
      await db.delete('gasto', where: 'id = ?', whereArgs: [id]);
      return 'ok';
    } catch (e) {
      return '$e';
    }
  }
}
