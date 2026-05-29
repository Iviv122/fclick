import 'dart:async';

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
  int _clicks = 0;
  Timer? _timer;
  bool _turnedOn = false;
  final Stopwatch _stopwatch = Stopwatch();

  int _lastTimerSpeed = 0;

  void _startTimer() {
    _timer?.cancel();
    if (_speed <= 0) return;
    _timer = Timer.periodic(Duration(milliseconds: _speed), _click);
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
  }

  void _turnOn() {
    if (_turnedOn) return;

    _turnedOn = true;
    _clicks = 0;
    _lastTimerSpeed = _speed;

    setState(() {});

    _stopwatch.reset();
    _stopwatch.start();

    _startTimer();
  }

  void _turnOff() {
    if (!_turnedOn) return;

    _turnedOn = false;

    setState(() {});

    _stopTimer();
  }

  void _click(Timer timer) {
    if (!_turnedOn) return;

    _clicks++;

    BixatKeyMouse.pressMouseButton(
      button: MouseButton.left,
      direction: Direction.click,
    );
  }

  void _setSpeed(int newSpeed) {
    if (_speed == newSpeed) return;

    _speed = newSpeed;

    if (_turnedOn && _speed != _lastTimerSpeed) {
      _lastTimerSpeed = _speed;
      _startTimer();
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            Wrap(
              spacing: 15,
              children: [
                Column(
                  children: [
                    const Text('Your current state:'),
                    Text(
                      '$_turnedOn',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Clicks (after stop):'),
                    Text(
                      '$_clicks',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Time passed:'),
                    Text(
                      '${_stopwatch.elapsed}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Enter speed (ms/click)",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => _setSpeed(int.tryParse(value) ?? 0),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: .center,
              children: [
                IconButton(
                  onPressed: () => _turnOn(),
                  icon: const Icon(Icons.play_arrow),
                  tooltip: "Start",
                ),
                IconButton(
                  onPressed: () => _turnOff(),
                  icon: const Icon(Icons.stop),
                  tooltip: "Stop",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
