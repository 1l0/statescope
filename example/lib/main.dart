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
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: context.read<AuthState>().login,
          child: const Text('Login'),
        ),
      ),
    );
  }
}

class AuthState extends ChangeNotifier {
  var _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool b) {
    _isLoggedIn = b;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
  }

  void logout() {
    isLoggedIn = false;
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
