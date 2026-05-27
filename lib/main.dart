import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BixatKeyMouse.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fclick',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xffbb86fc),
              brightness: Brightness.dark,
            ).copyWith(
              primaryContainer: const Color(0xffbb86fc),
              onPrimaryContainer: Colors.black,
              secondaryContainer: const Color(0xff03dac6),
              onSecondaryContainer: Colors.black,
              error: const Color(0xffcf6679),
              onError: Colors.black,
            ),
      ),
      home: const MyHomePage(title: 'Clicker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _speed = 0;
  bool _turnedOn = false;

  void _toggle(){
    setState(() {
      _turnedOn = !_turnedOn;
    });
  }

  void _setSpeed(int newSpeed) {
    setState(() {
      _speed = newSpeed;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Your current speed:'),
            Text('$_speed', style: Theme.of(context).textTheme.headlineMedium),
            TextField(
              decoration: InputDecoration(labelText: "Enter speed (ms/click)"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) =>
                  _setSpeed(value.isEmpty ? 0 : (int.tryParse(value) ?? 0)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toggle(),
        tooltip: 'Increment',
        child: (_turnedOn) ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
      ),
    );
  }
}
