import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCumbProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/new': (context) => const NewBreadCrumbWidget(),
        },
      ),
    );
  }
}

class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid;

  BreadCrumb({
    required this.isActive,
    required this.name,
  }) : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  String get title => name + (isActive ? ' > ' : '');

  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}

class BreadCumbProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [];
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.activate();
    }

    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrubsWidget extends StatelessWidget {
  const BreadCrubsWidget({
    Key? key,
    required this.breadCrumbs,
  }) : super(key: key);

  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb) {
        return Text(
          breadCrumb.title,
          style: TextStyle(
            color: breadCrumb.isActive ? Colors.blue : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          Consumer<BreadCumbProvider>(
            builder: (context, value, child) {
              return BreadCrubsWidget(
                breadCrumbs: value.items,
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/new");
            },
            child: const Text("Add New Bread Crumb"),
          ),
          TextButton(
            onPressed: () {
              final provider = context.read<BreadCumbProvider>();
              provider.reset();
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Bread Crumb"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter a new bread crumb here...",
            ),
          ),
          TextButton(
            onPressed: () {
              final text = _controller.text;

              if (text.isNotEmpty) {
                final breadCrumb = BreadCrumb(isActive: false, name: text);
                context.read<BreadCumbProvider>().add(breadCrumb);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add New"),
          ),
        ],
      ),
    );
  }
}
