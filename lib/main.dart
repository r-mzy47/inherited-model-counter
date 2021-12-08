import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(
      child: MyHomePage(
        title: "flutter counter using inherited model",
      ),
    ),
  );
}

class AppState {
  AppState({this.count1 = 0, this.count2 = 0});
  final int count1;
  final int count2;
  AppState copyWith({int? count1, int? count2}) {
    return AppState(
      count1: count1 ?? this.count1,
      count2: count2 ?? this.count2,
    );
  }
}

class AppStateScope extends InheritedModel<String> {
  const AppStateScope(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final AppState data;

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(AppStateScope oldWidget, Set dependencies) {
    if (dependencies.contains("counter1")) {
      return oldWidget.data.count1 != data.count1;
    }
    if (dependencies.contains("counter2")) {
      return oldWidget.data.count2 != data.count2;
    }
    return false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var state = AppState();

  void incrementCounter1() {
    setState(() {
      state = state.copyWith(count1: state.count1 + 1);
    });
  }

  void incrementCounter2() {
    setState(() {
      state = state.copyWith(count2: state.count2 + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppStateScope(
        state,
        child: widget.child,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CounterCard1(),
            CounterCard2(),
          ],
        ),
      ),
    );
  }
}

class CounterCard1 extends StatelessWidget {
  const CounterCard1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("building CounterCard1"),
        duration: Duration(milliseconds: 100),
      ));
    });
    final state =
        InheritedModel.inheritFrom<AppStateScope>(context, aspect: "counter1")!
            .data;
    return ElevatedButton(
        onPressed: MyApp.of(context).incrementCounter1,
        child: Text(state.count1.toString()));
  }
}

class CounterCard2 extends StatelessWidget {
  const CounterCard2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("building CounterCard2"),
        duration: Duration(milliseconds: 100),
      ));
    });
    final state =
        InheritedModel.inheritFrom<AppStateScope>(context, aspect: "counter2")!
            .data;
    return ElevatedButton(
        onPressed: MyApp.of(context).incrementCounter2,
        child: Text(state.count2.toString()));
  }
}
