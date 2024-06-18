[![pub package](https://img.shields.io/pub/v/statescope.svg)](https://pub.dev/packages/statescope)

# StateScope

A fork of [Simple State Management](https://github.com/theLee3/simple_state_management)

A dead simple state management using [InheritedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html).

## Features

- Ridiculously easy to use.
- Light weight & performant.
- Lazily creating state.

## Usage

Store state in a class that extends [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html),

```dart
class Counter extends ChangeNotifier {
    int count = 0;
    void countUp() {
        count++;
        notifyListeners();
    }
}
```

then put it in the `creator` of `StateScope`.

```dart
StateScope(
    creator: () => Counter(),
    child: Builder(
        builder: (context) {
            // watch() DO rebuild when state changes.
            final counter = context.watch<Counter>();
            return Column(
                children: [
                    Text('${counter.count}'),
                    ElevatedButton(
                        onPressed:(){
                            // read() DO NOT rebuild when state changes.
                            context.read<Counter>().countUp();
                        },
                        child: Text('Cout up'),
                    ),
                ],
            );
        },
    );
);
```

State is lazily-created by default. To create state immediately with `StateScope`, set `lazy` to `false`.

```dart
StateScope(
    lazy: false,
    ...
);
```
