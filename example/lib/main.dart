import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:statescope/statescope.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inherited Counter',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: StateScope(
        create: () => AuthState(),
        child: Builder(builder: (context) {
          final authState = context.watch<AuthState>();
          if (authState.isLoggedIn) {
            return StateScope(
              create: () => AppState(),
              child: const HomePage(title: 'Inherited Counter Demo'),
            );
          } else {
            return const LoginPage();
          }
        }),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: ((context) {
            final appState = context.watch<AppState>();
            return AppBar(
              title: Text(title, style: TextStyle(color: appState.textColor)),
              backgroundColor: appState.backgroundColor,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: true, child: Text('Logout')),
                  ],
                  onSelected: (_) => context.read<AuthState>().logout(),
                ),
              ],
            );
          }),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Builder(builder: (context) {
              return Text(
                context.watch<AppState>().count.toString(),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        final appState = context.watch<AppState>();
        return FloatingActionButton(
          onPressed: appState.incrementCounter,
          tooltip: 'Increment',
          backgroundColor: appState.backgroundColor,
          child: Icon(Icons.add, color: appState.textColor),
        );
      }),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    return Scaffold(
      body: Center(
        child: authState.isLogging
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: context.read<AuthState>().login,
                    child: const Text('Login'),
                  ),
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        authState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

enum _AuthState { loggedOut, logging, loggedIn }

class AuthState extends ChangeNotifier {
  var _authState = _AuthState.loggedOut;
  String? error;

  bool get isLogging => _authState == _AuthState.logging;
  bool get isLoggedIn => _authState == _AuthState.loggedIn;

  void login() {
    unawaited(_login());
  }

  Future<void> _login() async {
    error = null;
    _authState = _AuthState.logging;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final rand = Random().nextDouble();
      if (rand > 0.66) {
        throw Exception("random error example");
      }
    } catch (e) {
      error = e.toString();
      logout();
      return;
    }

    _authState = _AuthState.loggedIn;
    notifyListeners();
  }

  void logout() {
    _authState = _AuthState.loggedOut;
    notifyListeners();
  }
}

const _colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.yellow,
];

class AppState extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void incrementCounter() {
    _count++;
    _backgroundColor = _colors[count % 5];
    notifyListeners();
  }

  Color _backgroundColor = Colors.blue;
  Color get backgroundColor => _backgroundColor;

  Color get textColor =>
      _backgroundColor == Colors.yellow ? Colors.black87 : Colors.white;
}
