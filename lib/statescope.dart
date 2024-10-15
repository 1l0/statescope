/// A simple state management based on [InheritedNotifier].
library statescope;

import 'package:flutter/material.dart';

/// A [Widget] that provides that handles creation and disposal of a [ChangeNotifier].
class StateScope<T extends ChangeNotifier> extends StatefulWidget {
  /// Creates a [StateScope] that handles data management for an [InheritedNotifier].
  const StateScope(
      {super.key,
      required T Function() creator,
      this.lazy = true,
      required this.child,
      void Function(T)? onDispose})
      : _creator = creator,
        _onDispose = onDispose;

  /// The child widget of the [StateScope]. All dependents of the [StateScope]
  /// should be below this in the [Widget] tree.
  final Widget child;

  final T Function() _creator;

  final void Function(T)? _onDispose;

  /// Denotes whether the [ChangeNotifier] should be instantiated lazily (default).
  /// If lazily loaded, the [ChangeNotifier] will not be created until it is accessed
  /// for the first time. Set to false to create the [ChangeNotifier] as soon as
  /// the [StateScope] is created.
  final bool lazy;

  @override
  State<StateScope<T>> createState() => _StateScopeState<T>();
}

class _StateScopeState<T extends ChangeNotifier> extends State<StateScope<T>> {
  T? notifier;

  // lazily load
  T load() {
    if (notifier == null) {
      notifier = widget._creator();
      Future.delayed(Duration.zero, () => setState(() {}));
    }
    return notifier!;
  }

  @override
  void dispose() {
    if (notifier != null) widget._onDispose?.call(notifier!);
    notifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create [ChangeNotifier] on first build if not lazy.
    if (!widget.lazy) notifier ??= widget._creator();
    return _InheritedNotifier<T>(
        notifier: notifier, load: load, child: widget.child);
  }
}

class _InheritedNotifier<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  const _InheritedNotifier(
      {super.key,
      required super.notifier,
      required this.load,
      required super.child});

  final T Function() load;
}

/// An extension on [BuildContext] that provides easy access to data stored in an [InheritedNotifier].
extension ReadContext on BuildContext {
  /// Reads the state of the [ChangeNotifier], without subscribing to updates.
  /// [Widget]s accessing the data this way will NOT rebuild when the data changes.
  T read<T extends ChangeNotifier>() {
    final inheritedNotifier =
        getInheritedWidgetOfExactType<_InheritedNotifier<T>>();

    if (inheritedNotifier == null) {
      throw Exception('[${T.toString()}]  not found in context. '
          'Ensure that the [${T.toString()}] is created by a [StateScope] above this [BuildContext].\n'
          'The most common cause of is using a [BuildContext] at the [StateScope] level rather than below it.\n'
          'If you need to use the [${T.toString()}]  directly in the child parameter of the [StateScope],\n'
          'consider wrapping the child in a [Builder].');
    }

    // Lazily load [ChangeNotifier] on first access if needed.
    return inheritedNotifier.notifier ?? inheritedNotifier.load();
  }

  /// Watches the state of the [ChangeNotifer], subscribing to updates.
  /// [Widget]s accessing the data this way will rebuild when the data changes.
  T watch<T extends ChangeNotifier>() {
    final inheritedNotifier =
        dependOnInheritedWidgetOfExactType<_InheritedNotifier<T>>();

    if (inheritedNotifier == null) {
      throw Exception('[${T.toString()}] not found in context. '
          'Ensure that the [${T.toString()}] is created by a [StateScope] above this [BuildContext].\n'
          'The most common cause of is using a [BuildContext] at the [StateScope] level rather than below it.\n'
          'If you need to use the [${T.toString()}]  directly in the child parameter of the [StateScope],\n'
          'consider wrapping the child in a [Builder].');
    }
    // Lazily load [ChangeNotifier] on first access if needed.
    return inheritedNotifier.notifier ?? inheritedNotifier.load();
  }
}
