import 'package:expense_tracker/utils/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Opens the dialog from a button and stores whatever it returns in [result].
  Future<void> openDialog(WidgetTester tester, void Function(({String name, double amount})?) onResult) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () async => onResult(await showNameAmountDialog(
            context,
            title: 'Add Expense',
            nameLabel: 'Expense Name',
            amountLabel: 'Price',
          )),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('returns the name and parsed amount, accepting a decimal comma', (tester) async {
    ({String name, double amount})? result;
    await openDialog(tester, (r) => result = r);

    await tester.enterText(find.widgetWithText(TextField, 'Expense Name'), ' Coffee ');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '3,50');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(result, (name: 'Coffee', amount: 3.5));
  });

  testWidgets('stays open and shows errors for invalid input', (tester) async {
    await openDialog(tester, (_) {});

    await tester.enterText(find.widgetWithText(TextField, 'Price'), '-5');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Enter a positive number, e.g. 12,50'), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget); // dialog still open
  });

  testWidgets('returns null when cancelled', (tester) async {
    var called = false;
    ({String name, double amount})? result = (name: 'x', amount: 1);
    await openDialog(tester, (r) {
      called = true;
      result = r;
    });

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(called, isTrue);
    expect(result, isNull);
  });
}
