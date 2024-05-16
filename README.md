[![pub package](https://img.shields.io/pub/v/statescope.svg)](https://pub.dev/packages/statescope)

# StateScope

A fork of [Simple State Management](https://github.com/theLee3/simple_state_management)

A state management solution that is light weight, easy to use, and performant. Uses Flutter's [InheritedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html).

## Features

- Ridiculously easy to use.
- Light weight & performant.
- Lazily load data.

## Usage

Store state in a class that extends [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), then create with `StateScope`.

```dart
StateScope(
    create: () => AppState(),
    child: ...
);
```

Data is lazily-loaded by default. To disable and load immediately when `StateScope` is built, set `lazy` to `false`.

```dart
StateScope(
    create: () => AppState(),
    lazy: false,
    child: ...
);
```

Access state via `BuildContext` wherever needed.

```dart
// DO rebuild widget when state changes.
context.watch<AppState>();

// DO NOT rebuild widget when state changes.
context.read<AppState>();
```

Pass data that has already been instantiated between `BuildContext`s by using `StateScope.value`.

```dart
final appState = context.read<AppState>();
Navigator.of(context).push(
    MaterialPageRoute(builder: (context) {
        return StateScope.value(
            value: appState,
            child: ...,
        );
    }),
);
```
