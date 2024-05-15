import 'package:flutter/material.dart';
import 'package:simple_state_management/simple_provider.dart';

import 'states.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inherited Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider(
        create: () => AuthState(),
        child: Builder(builder: (context) {
          final authState = context.watch<AuthState>();
          if (authState.isLoggedIn) {
            return Provider(
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
                    const PopupMenuItem(child: Text('Logout'), value: true),
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
