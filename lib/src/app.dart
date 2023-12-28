import 'package:flutter/material.dart';
import 'package:flutter_101_app/src/blocs/sizing.dart';
import 'package:flutter_101_app/src/models/reference_table.dart';
import 'package:flutter_101_app/src/models/status.dart';
import 'package:flutter_101_app/src/models/values.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'Story Point sizing'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(title),
      ),
      body: StreamBuilder(
          stream: sizingBloc.latestStatus,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _renderStatus(context, snapshot.data!);
            }

            if (snapshot.hasError) {
              return _renderError(context, snapshot.error!);
            }

            return _renderStatus(context, Status(CurrentSelection.none()));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sizingBloc.updateCurrentSelection(CurrentSelection.none());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  _renderError(BuildContext context, Object error) {
    return Center(
        child: Column(children: [
      const Text("An error occurred"),
      Text(error.toString())
    ]));
  }

  _renderStatus(BuildContext context, Status status) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        children: [
          _renderDropdown(
              context,
              "Uncertainty:",
              _renderDropdownMenuItems(
                  [Value.small, Value.medium, Value.large]),
              status.currentSelection.selectedUncertainty,
              (value) => sizingBloc.updateCurrentSelection(
                  status.currentSelection.withUncertainty(value))),
          _renderDropdown(
              context,
              "Complexity:",
              _renderDropdownMenuItems(status.compatibleComplexity().toList()),
              status.currentSelection.selectedComplexity,
              (value) => sizingBloc.updateCurrentSelection(
                  status.currentSelection.withComplexity(value))),
          _renderDropdown(
              context,
              "Effort:",
              _renderDropdownMenuItems(status.compatibleEffort().toList()),
              status.currentSelection.selectedEffort,
              (value) => sizingBloc.updateCurrentSelection(
                  status.currentSelection.withEffort(value))),
          Row(
            children: [
              const Text("Story points:"),
              status.currentSelection.isComplete()
                  ? Text(
                      table
                          .resolveStoryPoints(status.currentSelection)
                          .toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  : const Text("N/A")
            ],
          )
        ],
      ),
    );
  }

  _renderDropdown(
      BuildContext context,
      String label,
      List<DropdownMenuItem<Value>> items,
      Value? value,
      void Function(dynamic value) onChanged) {
    return Row(
      children: [
        Text(label),
        DropdownButton<Value>(
          items: items,
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }

  _renderDropdownMenuItems(List<Value> values) {
    return values
        .map((v) => DropdownMenuItem(
              value: v,
              child: Text(toString(v)),
            ))
        .toList();
  }
}
