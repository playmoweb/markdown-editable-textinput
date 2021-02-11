import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

void main() {
  testWidgets('MarkdownTextInput has all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: MarkdownTextInput(print, 'initial value'))));
    await tester.pumpAndSettle();
    final boldKey = const Key('bold_button');
    final italicKey = const Key('italic_button');
    final h1Key = const Key('H1_button');
    final h2Key = const Key('H2_button');
    final h3Key = const Key('H3_button');
    final linkKey = const Key('link_button');
    final listKey = const Key('list_button');

    expect(find.byKey(boldKey), findsOneWidget);
    expect(find.byKey(italicKey), findsOneWidget);
    expect(find.byKey(h1Key), findsOneWidget);
    expect(find.byKey(h2Key), findsOneWidget);
    expect(find.byKey(h3Key), findsOneWidget);
    expect(find.byKey(linkKey), findsOneWidget);
    expect(find.byKey(listKey), findsOneWidget);
  });

  testWidgets('MarkdownTextInput has only the specified functions',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput(
      print,
      'initial value',
      availableFunctions: [MarkdownType.bold, MarkdownType.italic],
    ))));
    await tester.pumpAndSettle();
    final boldKey = const Key('bold_button');
    final italicKey = const Key('italic_button');

    expect(find.byKey(boldKey), findsOneWidget);
    expect(find.byKey(italicKey), findsOneWidget);
  });

  testWidgets('MarkdownTextInput make bold from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('bold_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '**initial value**');
  });

  testWidgets('MarkdownTextInput make italic from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('italic_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '_initial value_');
  });

  testWidgets('MarkdownTextInput make H1 from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('H1_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '# initial value');
  });

  testWidgets('MarkdownTextInput make H2 from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('H2_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '## initial value');
  });

  testWidgets('MarkdownTextInput make H3 from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('H3_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '### initial value');
  });

  testWidgets('MarkdownTextInput make link from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('link_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '[initial value](initial value)');
  });

  testWidgets('MarkdownTextInput make list from selection',
      (WidgetTester tester) async {
    var initialValue = 'initial\nvalue';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final listKey = const Key('list_button');
    await tester.tap(find.byKey(listKey));

    expect(initialValue, '* initial\n* value');
  });
}
