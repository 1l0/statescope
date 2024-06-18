import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:statescope/statescope.dart';

void main() {
  testWidgets('StateScope', (tester) async {
    final app = MaterialApp(
      home: StateScope(
        creator: () => Counter(),
        child: Builder(builder: (context) {
          final counter = context.watch<Counter>();
          return Column(
            children: [
              Text('${counter.count}'),
              ElevatedButton(
                onPressed: () {
                  context.read<Counter>().countUp();
                },
                child: const Text('Count up'),
              ),
            ],
          );
        }),
      ),
    );
    await tester.pumpWidget(app);
    final resultFinder = find.byType(Text);
    var result = tester.firstWidget<Text>(resultFinder);
    expect(result.data, equals('0'));
    final button = find.text('Count up');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
    result = tester.firstWidget<Text>(resultFinder);
    expect(result.data, equals('1'));
  });
}

class Counter extends ChangeNotifier {
  int count = 0;
  void countUp() {
    count++;
    notifyListeners();
  }
}
