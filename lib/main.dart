import 'package:flutter/material.dart';
import 'package:todo_list/database_helper.dart';

final dbhelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbhelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSQflite Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: "Times New Roman",
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: "BOB",
      DatabaseHelper.columnAge: "32"
    };
    final id = await dbhelper.insert(row);
    debugPrint("INSERTED ROW ID : $id");
  }

  void _query() async {
    final allRows = await dbhelper.queryAllRows();
    debugPrint("Query All Rows :");
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnID: 1,
      DatabaseHelper.columnName: "Mary",
      DatabaseHelper.columnAge: 32,
    };
    final rowsAffected = await dbhelper.update(row);
    debugPrint("Update $rowsAffected row(s)");
  }

  void _delete() async {
    final id = await dbhelper.queryRowCount();
    final rowdDeleted = await dbhelper.delete(id);
    debugPrint('Deleted $rowdDeleted row(s) : row $id');
  }
}
