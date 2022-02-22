import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Sliver App Bar'),
          ),
          const SliverAnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: 1,
            sliver: SliverToBoxAdapter(
              child: FlutterLogo(
                size: 100,
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildListDelegate(
              [
                const Icon(Icons.animation),
                const Icon(Icons.translate),
                const Icon(Icons.save),
                const Icon(Icons.person),
              ],
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(
              thickness: 4,
            ),
          ),
          // fill remaining space
          // const SliverFillRemaining(
          //   child: Center(
          //     child: FlutterLogo(size: 100,),
          //   ),
          // ),
          SliverLayoutBuilder(
            builder: (BuildContext context, SliverConstraints constraints) {
              //AxisDirection is sliver direction
              //GrowDirection is sliver item grow direction
              //ScrollDirection is gesture direction
              // -> you want scroll down your gesture is reverse
              //ScrollOffset is overflow screen size
              // remainingPaintExtent is how many space can give your render
              print(constraints);
              return const SliverToBoxAdapter();
            },
          ),
          const SliverToBoxAdapter(
            child: Placeholder(fallbackHeight: 2000,),
          )
        ],
      ),
    );
  }
}
