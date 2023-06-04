import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_auto_form/easy_auto_form.dart';

void main() {
  group('EasyAutoForm', () {
    testWidgets('Renders all fields', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final entity = {
        'name': 'John Doe',
        'age': 30,
        'height': 1.8,
        'isEmployed': true,
        'birthday': DateTime(1990, 1, 1),
        'notes': 'Some notes',
      };
      final widget = EasyAutoForm(
        formKey: formKey,
        entity: entity,
        onSave: (_) {},
      );

      await tester.pumpWidget(widget);

      expect(find.text('name'), findsOneWidget);
      expect(find.text('age'), findsOneWidget);
      expect(find.text('height'), findsOneWidget);
      expect(find.text('isEmployed'), findsOneWidget);
      expect(find.text('birthday'), findsOneWidget);
      expect(find.text('notes'), findsOneWidget);
    });

    testWidgets('Saves entity on submit', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final entity = {
        'name': 'John Doe',
        'age': 30,
        'height': 1.8,
        'isEmployed': true,
        'birthday': DateTime(1990, 1, 1),
        'notes': 'Some notes',
      };
      final widget = Scaffold(
        body: Center(
          child: EasyAutoForm(
            formKey: formKey,
            entity: entity,
            onSave: expectAsync1((result) {
              expect(result, {
                'name': 'Jane Doe',
                'age': 25,
                'height': 1.7,
                'isEmployed': false,
                'birthday': DateTime(1995, 1, 1),
                'notes': 'New notes',
              });
            }),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'name'), 'Jane Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'age'), '25');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'height'), '1.7');
      await tester.tap(find.widgetWithText(CheckboxListTile, 'isEmployed'));
      await tester.enterText(
          find.widgetWithText(TextFormField, 'birthday'), '1995-01-01');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'notes'), 'New notes');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Salva'));

      await tester.pump();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('1.7'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(find.text('1995-01-01'), findsOneWidget);
      expect(find.text('New notes'), findsOneWidget);
    });
  });
}
