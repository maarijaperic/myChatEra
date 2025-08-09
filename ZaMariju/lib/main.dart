import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/screen_love.dart';

void main() {
  runApp(const MyApp());
}

/// Screens are stored here so the home page can expose indices 1..N.
final List<Widget> appScreens = <Widget>[
  const LoveCountWrappedScreen(
    title: 'Comparativa de "Te amo"',
    leftName: 'Alegría',
    rightName: 'Tranquilidad',
    leftValue: 1564,
    rightValue: 1320,
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Index Navigator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Choose Screen', screens: appScreens),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.screens});

  final String title;
  final List<Widget> screens;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Store the selected index in 0-based form; UI shows 1-based.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final int numScreens = widget.screens.length;
    final bool hasScreens = numScreens > 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                hasScreens
                    ? 'Select an index (1-$numScreens)'
                    : 'No screens available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (hasScreens)
                DropdownButton<int>(
                  value: _selectedIndex + 1, // display 1-based
                  items: List<DropdownMenuItem<int>>.generate(
                    numScreens,
                    (int i) => DropdownMenuItem<int>(
                      value: i + 1, // 1-based value
                      child: Text('Index ${i + 1}'),
                    ),
                  ),
                  onChanged: (int? displayIndex) {
                    if (displayIndex == null) return;
                    setState(() {
                      _selectedIndex = displayIndex - 1; // convert to 0-based
                    });
                  },
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: hasScreens
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute<Widget>(
                            builder: (_) => widget.screens[_selectedIndex],
                          ),
                        );
                      }
                    : null,
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
