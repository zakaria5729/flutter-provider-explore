import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
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
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            initialData: Seconds(),
            value: Stream<Seconds>.periodic(
              const Duration(seconds: 1),
              (_) => Seconds(),
            ),
          ),
          StreamProvider.value(
            initialData: MoreSeconds(),
            value: Stream<MoreSeconds>.periodic(
              const Duration(seconds: 5),
              (_) => MoreSeconds(),
            ),
          ),
        ],
        child: Row(
          children: const [
            SecondsWidget(),
            MoreSecondsWidget(),
          ],
        ),
      ),
    );
  }
}

String now() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value;
  Seconds() : value = now();
}

@immutable
class MoreSeconds {
  final String value;
  MoreSeconds() : value = now();
}

class SecondsWidget extends StatelessWidget {
  const SecondsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.yellow,
        height: 100,
        child: Text(seconds.value),
      ),
    );
  }
}

class MoreSecondsWidget extends StatelessWidget {
  const MoreSecondsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moreSeconds = context.watch<MoreSeconds>();

    return Expanded(
      child: Container(
        height: 100,
        color: Colors.blue,
        child: Text(moreSeconds.value),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
