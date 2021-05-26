import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

void main() {
  testWidgets('MarkdownTextInput has all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: MarkdownTextInput(print, 'initial value'))));
    final boldKey = const Key('bold_button');
    final italicKey = const Key('italic_button');
    final strikethroughKey = const Key('strikethrough_button');
    final hKey = const Key('H#_button');
    final h1Key = const Key('H1_button');
    final h2Key = const Key('H2_button');
    final h3Key = const Key('H3_button');
    final h4Key = const Key('H4_button');
    final h5Key = const Key('H5_button');
    final h6Key = const Key('H6_button');
    final linkKey = const Key('link_button');
    final listKey = const Key('list_button');
    final quoteKey = const Key('quote_button');
    final separatorKey = const Key('separator_button');
    final imageKey = const Key('image_button');

    expect(find.byKey(boldKey), findsOneWidget);
    expect(find.byKey(italicKey), findsOneWidget);
    expect(find.byKey(strikethroughKey), findsOneWidget);
    expect(find.byKey(hKey), findsOneWidget);
    expect(find.byKey(h1Key), findsOneWidget);
    expect(find.byKey(h2Key), findsOneWidget);
    expect(find.byKey(h3Key), findsOneWidget);
    expect(find.byKey(h4Key), findsOneWidget);
    expect(find.byKey(h5Key), findsOneWidget);
    expect(find.byKey(h6Key), findsOneWidget);
    expect(find.byKey(linkKey), findsOneWidget);
    expect(find.byKey(listKey), findsOneWidget);
    expect(find.byKey(quoteKey), findsOneWidget);
    expect(find.byKey(separatorKey), findsOneWidget);
    expect(find.byKey(imageKey), findsOneWidget);
  });

  testWidgets('MarkdownTextInput make bold from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('bold_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '**initial value**');
  });

  testWidgets('MarkdownTextInput make italic from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('italic_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '_initial value_');
  });

  testWidgets('MarkdownTextInput make strikethrough from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('strikethrough_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '~~initial value~~');
  });

  testWidgets('MarkdownTextInput make code from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('code_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '```initial value```');
  });

  testWidgets('MarkdownTextInput make link from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('link_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '[initial value](initial value)');
  });

  testWidgets('MarkdownTextInput make list from selection', (WidgetTester tester) async {
    var initialValue = 'initial\nvalue';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('list_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '* initial\n* value');
  });

  testWidgets('MarkdownTextInput make blockquote from selection', (WidgetTester tester) async {
    var initialValue = 'initial\nvalue';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('quote_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '> initial\n> value');
  });

  testWidgets('MarkdownTextInput make separator from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('separator_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '\n------\ninitial value');
  });

  testWidgets('MarkdownTextInput make image link from selection', (WidgetTester tester) async {
    var initialValue = 'initial value';
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MarkdownTextInput((String value) {
      initialValue = value;
    }, initialValue))));

    final formfield = tester.widget<EditableText>(find.text(initialValue));
    formfield.controller.selection = TextSelection(baseOffset: 0, extentOffset: initialValue.length);

    final boldKey = const Key('image_button');
    await tester.tap(find.byKey(boldKey));

    expect(initialValue, '![initial value](initial value)');
  });
}
