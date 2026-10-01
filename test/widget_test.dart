import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_input_field/main.dart';

void main() {
  testWidgets('validates, corrects, toggles password, submits and resets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TutorialApp());
    final fields = find.byType(TextFormField);
    await tester.tap(find.text('Validate form'));
    await tester.pumpAndSettle();
    for (final name in ['Email', 'Password', 'Username', 'Phone']) {
      expect(find.text('$name is required'), findsOneWidget);
    }
    await tester.enterText(fields.at(0), 'bad');
    await tester.enterText(fields.at(1), 'short');
    await tester.enterText(fields.at(2), 'a!');
    await tester.enterText(fields.at(3), '12+34');
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(
      find.text('Use 3–20 letters, digits or underscores'),
      findsOneWidget,
    );
    expect(
      find.text('Use 7–15 digits with an optional leading +'),
      findsOneWidget,
    );
    await tester.enterText(fields.at(0), 'learner@example.com');
    await tester.enterText(fields.at(1), 'DemoOnly123!');
    await tester.enterText(fields.at(2), 'flutter_learner');
    await tester.enterText(fields.at(3), '+12025550123');
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsNothing);
    var password = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(password.obscureText, isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pumpAndSettle();
    password = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(password.obscureText, isFalse);
    await tester.tap(find.text('Validate form'));
    await tester.pumpAndSettle();
    expect(find.text('All fields are valid!'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('All fields are valid!'), findsNothing);
    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.controller!.text, isEmpty);
    }
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).obscureText,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
