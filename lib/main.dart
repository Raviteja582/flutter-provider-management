import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
// Provide the model to all widgets within the app. We're using
// ChangeNotifierProvider because that's a simple way to rebuild
// widgets when a model changes. We could also just use
// Provider, but then we would have to listen to Counter ourselves.
//
// Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
// Initialize the model in the builder. That way, Provider
// can own Counter's lifecycle, making sure to call `dispose`
// when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;
  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value--;
      notifyListeners();
    }
  }

  String getAgeStageMessage() {
    if (value >= 0 && value <= 12) {
      return "You're a child!";
    } else if (value >= 13 && value <= 19) {
      return "Teenager time!";
    } else if (value >= 20 && value <= 30) {
      return "You're a young adult!";
    } else if (value >= 31 && value <= 50) {
      return "You're an adult now!";
    } else if (value >= 51) {
      return "Golden years!";
    }
    return "";
  }

  Color getBackgroundColor() {
    if (value >= 0 && value <= 12) {
      return Colors.lightBlue;
    } else if (value >= 13 && value <= 19) {
      return Colors.lightGreen;
    } else if (value >= 20 && value <= 30) {
      return Colors.yellowAccent;
    } else if (value >= 31 && value <= 50) {
      return Colors.orange;
    } else if (value >= 51) {
      return Colors.grey.shade300;
    }
    return Colors.white;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Milestones Counter'),
      ),
      body: Container(
        color: counter.getBackgroundColor(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your Age:',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '${counter.value}',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 20),
              Text(
                counter.getAgeStageMessage(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: counter.increment,
                    child: const Text('Increment'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: counter.decrement,
                    child: const Text('Decrement'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
