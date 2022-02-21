import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          DefaultTextStyle(
            style: const TextStyle(fontSize: 80, color: Colors.red),
            child: SliverPrototypeExtentList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return LayoutBuilder(builder: (context, constraint) {
                    print(constraint); // height 40 fix
                    return const Text(
                      'Hello',
                    );
                  });
                },
                childCount: 3,
              ),
              prototypeItem: const Text(
                "",
              ),
            ),
          ),
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return LayoutBuilder(builder: (context, constraint) {
                  print(constraint); //height 100
                  return const FlutterLogo(
                    size: 10000,
                  );
                });
              },
              childCount: 2,
            ),
            itemExtent: 100,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const FlutterLogo(),
                const FlutterLogo(
                  size: 100,
                ),
                const FlutterLogo(
                  size: 200,
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  height: 50,
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
              childCount: 8,
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
              childCount: 10,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
          ),
          SliverFillViewport(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.green,
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
