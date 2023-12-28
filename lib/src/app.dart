import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'blocs/sizing.dart';
import 'models/reference_table.dart';
import 'models/status.dart';
import 'models/values.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Size Point sizing Cheat Sheet',
      theme: ThemeData(
          useMaterial3: true,

          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(color: Colors.blue)),
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
        margin: const EdgeInsets.all(15),
        child: _renderRowOrColumn(
          context,
          [
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _renderDropdown(
                      context,
                      "Uncertainty",
                      _renderDropdownMenuItems(
                          [Value.small, Value.medium, Value.large]),
                      status.currentSelection.selectedUncertainty,
                      (value) => sizingBloc.updateCurrentSelection(
                          status.currentSelection.withUncertainty(value))),
                  _renderDropdown(
                      context,
                      "Complexity",
                      _renderDropdownMenuItems(
                          status.compatibleComplexity().toList()),
                      status.currentSelection.selectedComplexity,
                      (value) => sizingBloc.updateCurrentSelection(
                          status.currentSelection.withComplexity(value))),
                  _renderDropdown(
                      context,
                      "Effort",
                      _renderDropdownMenuItems(
                          status.compatibleEffort().toList()),
                      status.currentSelection.selectedEffort,
                      (value) => sizingBloc.updateCurrentSelection(
                          status.currentSelection.withEffort(value))),
                ],
              ),
            ),
            _renderStoryPoints(context, status.currentSelection)
          ],
        ));
  }

  _renderRowOrColumn(BuildContext context, List<Widget> children) {
    if (MediaQuery.of(context).size.width > 550) {
      return SizedBox(
          height: 175,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ));
    }

    return SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ));
  }

  _renderStoryPoints(BuildContext context, CurrentSelection currentSelection) {
    if (!currentSelection.isComplete()) {
      return const SizedBox();
    }
    final storyPoints = table.resolveStoryPoints(currentSelection).toString();
    return Container(
        margin: const EdgeInsets.only(left: 15),
        child: SizedBox(
            width: 200,
            height: 100,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        "Story points:",
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: storyPoints));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Value copied to Clipboard'),
                      ));
                    },
                    child: Text(
                      storyPoints,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                ],
              ),
            )));
  }

  _renderDropdown(
      BuildContext context,
      String label,
      List<DropdownMenuItem<Value>> items,
      Value? value,
      void Function(dynamic value) onChanged) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text("$label:")),
        SizedBox(
            width: 150,
            child: DropdownButton<Value>(
                isExpanded: true,
                items: items,
                value: value,
                onChanged: onChanged,
                hint: const Text("none")))
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
