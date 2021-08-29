import 'dart:math';
import 'package:gasto_control/model/Categoria.dart';
import 'package:gasto_control/model/Gasto.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

class SqliteFunc {
  Future<String> loadAssetCreatetables() async {
    return await rootBundle.loadString('assets/sqlite_start.txt');
  }

  Future<String> loadAssetInsertCategorias() async {
    return await rootBundle.loadString('assets/insert_categorias_basic.txt');
  }

  Future<String> limpagasto() async {
    final Database db = await getDatabase();
    db.delete('gasto');

    return '';
  }

  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  Future<List<Categoria>> getCategorias() async {
    final Database db = await getDatabase();
    List<Categoria> categorias = [];

    List<Map<String, dynamic>> maps = [];
    maps = await db.query('categorias', orderBy: 'descricao');
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
        'categoria': gst.categoria,
        'pago': gst.pago,
        'id_parcelamento': idparcelamento
      });
      print('ok');
      return 'ok';
    } catch (e) {
      print(e);
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
            'categoria': gst.categoria,
            'pago': gst.pago,
            'id_parcelamento': idparcelamento
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
        'categoria': '1',
        'pago': 'false',
        'id_parcelamento': 0
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
      if (element['pago'] == 'false') {
        pago = false;
      } else {
        pago = true;
      }

      gst = new Gasto(
          categoria: '${element['categoria']}',
          data: DateTime.parse(element['data']),
          descricao: element['descricao'],
          formapagamento: element['formapagamento'],
          id: element['id'],
          pago: pago,
          tipo: element['tipo'],
          valor: element['valor']);

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

    maps.forEach((element) {
      bool pago = false;
      if (element['pago'] == 'false') {
        pago = false;
      } else {
        pago = true;
      }
      var dr = new Gasto(
          categoria: '${element['categoria']}',
          data: DateTime.parse(element['data']),
          descricao: element['descricao'],
          formapagamento: element['formapagamento'],
          id: element['id'],
          pago: pago,
          tipo: element['tipo'],
          valor: element['valor']);

      gastos.add(dr);
    });
    return gastos;
  }

  Future<Database> getDatabase() async {
    List<String> sqlrun = [];
    sqlrun.add("CREATE TABLE IF NOT EXISTS gasto (" +
        "  id INTEGER PRIMARY KEY ASC AUTOINCREMENT," +
        "  descricao STRING (500)," +
        "  data DATE NOT NULL," +
        "  tipo            INTEGER NOT NULL," +
        "  valor           DOUBLE NOT NULL," +
        "  formapagamento  STRING (200)," +
        "  categoria       STRING (200)," +
        "  pago            BOOLEAN NOT NULL," +
        "  id_parcelamento INTEGER );");

    sqlrun.add("CREATE TABLE IF NOT EXISTS parcelamentos (" +
        " id          INTEGER PRIMARY KEY AUTOINCREMENT," +
        " descricao   STRING," +
        " qntparcelas INTEGER NOT NULL," +
        " valortotal  DOUBLE  NOT NULL," +
        " data        DATE    NOT NULL," +
        " pago        BOOLEAN NOT NULL );");

    sqlrun.add("CREATE TABLE IF NOT EXISTS formaspagamento (" +
        " id        INTEGER      PRIMARY KEY AUTOINCREMENT," +
        " descricao STRING (200) NOT NULL);");

    sqlrun.add("CREATE TABLE IF NOT EXISTS categorias (" +
        "id        INTEGER      PRIMARY KEY AUTOINCREMENT," +
        "descricao STRING (200) ," +
        "tipo      STRING (200), sistema BOOLEAN NOT NULL);");

    String createtableappuser = '';

    sqlrun.forEach((sqlr) {
      createtableappuser = '$createtableappuser$sqlr';
    });

    return openDatabase(
      // join faz aa/ + /a = aa/a
      p.join(await getDatabasesPath(), 'dbcontrolgastos.db'),
      version: 6,
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

  Future clearcategorias() async {
    final Database db = await getDatabase();
    await db.delete('categorias');
  }

  Future initCategorias() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('categorias');

    List<String> categoriasstart = [];

    categoriasstart.add('Prestação do imóvel/aluguel|Fixas');
    categoriasstart.add('Condomínio|Despesas Fixas');
    categoriasstart.add('Planos de saúde e de previdência privada|Fixas');
    categoriasstart.add('Mensalidade escolar|Fixas');
    categoriasstart.add('Prestação do carro|Fixas');
    categoriasstart.add('Plano da Internet|Fixas');
    categoriasstart.add('Assinatura de TV a cabo|Fixas');
    categoriasstart.add('Assinatura de jornais e revistas|Fixas');
    categoriasstart.add('Faxineira/empregada doméstica|Fixas');
    categoriasstart.add('Cursos|Fixas');
    categoriasstart.add('Academia de ginástica|Fixas');
    categoriasstart.add('Supermercado|Semifixas');
    categoriasstart.add('Feira|Semifixas');
    categoriasstart.add('Açougue|Semifixas');
    categoriasstart.add('Energia elétrica|Semifixas');
    categoriasstart.add('Gás|Semifixas');
    categoriasstart.add('Telefone|Semifixas');
    categoriasstart.add('Combustível|Semifixas');
    categoriasstart.add('Roupas|Variáveis');
    categoriasstart.add('Calçados|Variáveis');
    categoriasstart.add('Bares e restaurantes|Variáveis');
    categoriasstart.add('Teatro, cinema e shows|Variáveis');
    categoriasstart.add('Farmácia|Variáveis');
    categoriasstart.add('Viagens|Variáveis');
    categoriasstart.add('Livraria|Variáveis');
    categoriasstart.add('Presente|Variáveis');
    categoriasstart.add('Locadora|Variáveis');
    categoriasstart.add('Lavanderia|Variáveis');
    categoriasstart.add('Salão de beleza|Variáveis');
    categoriasstart.add('Gorjetas e esmolas|Variáveis');
    categoriasstart
        .add('Juros do cheque especial e empréstimos pessoais|Variáveis');
    categoriasstart.add('Tarifas bancárias|Variáveis');
    categoriasstart.add('Salario/Adiantamento/13º|Fixas');
    categoriasstart.add('Impostos (IPVU/IPVA/Etc..)|Fixas');
    categoriasstart.add('Outros|Fixas');
    categoriasstart.add('Manutenção de Veiculos|Fixas');

    if (result.length != categoriasstart.length) {
      //String sql = await loadAssetInsertCategorias();

      var batch = db.batch();

      try {
        categoriasstart.forEach((element) {
          print('INSERINDO CATEGORIA= $element');
          List<String> substr = element.split('|');
          batch.insert(
            'categorias',
            {'descricao': substr[0], 'tipo': substr[1], 'sistema': 'true'},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });

        await batch.commit(noResult: true);
      } catch (e) {
        print(e);
      }
    } else {
      print('Categorias Iniciais já cadastradas (${result.length})');
    }
  }
}
