import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

class SqliteFunc {
  Future<String> loadAssetCreatetables() async {
    return await rootBundle.loadString('assets/sqlite_start.txt');
  }

  Future<Null> testsqlite() async {
    String sqlinitial = await loadAssetCreatetables();

    List<String> substr = sqlinitial.split(';');

    substr.forEach((element) {
      print(element);
    });
    // print(substr);
  }

  Future<Database> getDatabase() async {
    String sqlinitial = await loadAssetCreatetables();

    List<String> sqlrun = sqlinitial.split('|');
    String createtableappuser = '';

    sqlrun.forEach((sqlr) {
      createtableappuser = '$createtableappuser$sqlr';
    });

    return openDatabase(
      // join faz aa/ + /a = aa/a
      p.join(await getDatabasesPath(), 'dbcontrolgastos.db'),
      version: 1,
      onOpen: (db) {
        print('OPEN DATABASE');
        try {
          db.execute(createtableappuser);
        } catch (e) {
          print(e);
        }

        //var batch = db.batch();

        //sqlrun.forEach((element) {
        //  batch.execute(element.trim());
        //  print('exec=${element.trim()}');
        //});
        //batch.commit(noResult: false);
      },
      onCreate: (db, version) {
        print('CREATE DATABASE');

        try {
          db.execute(createtableappuser);
        } catch (e) {
          print(e);
        }

        //var batch = db.batch();
        //sqlrun.forEach((element) {
        //  batch.execute(element.trim());
        //  print('exec=${element.trim()}');
        //});
        //batch.commit(noResult: false);
      },
    );
  }
}
