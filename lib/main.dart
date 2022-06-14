// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class BreadCumb {
  bool isActive;
  final String name;
  final String uuid;

  BreadCumb({
    required this.isActive,
    required this.name,
  }) : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  String get title => name + (isActive ? ' > ' : '');

  @override
  bool operator ==(covariant BreadCumb other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}

class BreadCumbProvider extends ChangeNotifier {
  final List<BreadCumb> _items = [];
  UnmodifiableListView<BreadCumb> get items => UnmodifiableListView(_items);

  void add(BreadCumb breadCumb) {
    for (final item in _items) {
      item.activate();
    }

    _items.add(breadCumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
    );
  }
}
