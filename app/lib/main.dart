import 'package:flutter/material.dart';
import "package:app/database/database_connection.dart";


import 'package:sqflite/sqlite_api.dart';void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _teste(),
    );
  }

  Container _teste() {
    Future<Database> db = DatabaseConnection().db;
    return Container(
      child: Text("Teste"),
    );
  }
}
